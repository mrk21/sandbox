package reporter

import (
	"encoding/json"
	"errors"
	"log"
	"strconv"
	"strings"
	"time"

	"github.com/go-redis/redis"
	"github.com/google/uuid"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
	"github.com/mrk21/sandbox/go_jobworker/pkg/redislua"
)

type Reporter struct {
	rclient        *redis.Client
	que            *jobque.JobQueue
	reportDuration time.Duration
	id             string
}

type ReportData struct {
	ExecRate float64 `json:"execRate"`
	QueSize  int     `json:"queSize"`
}

func New(rclient *redis.Client, que *jobque.JobQueue, reportDuration time.Duration) (*Reporter, error) {
	uuid, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}
	r := &Reporter{
		rclient:        rclient,
		que:            que,
		reportDuration: reportDuration,
		id:             uuid.String(),
	}
	return r, nil
}

func (r *Reporter) Report() ([]ReportData, error) {
	data, err := r.rclient.LRange("jobworker:report:data", 0, 49).Result()
	if err == redis.Nil {
		return []ReportData{}, nil
	} else if err != nil {
		return []ReportData{}, err
	}
	result := []ReportData{}
	for _, d := range data {
		item := ReportData{}
		json.Unmarshal([]byte(d), &item)
		result = append(result, item)
	}
	return result, nil
}

func (r *Reporter) RecordLoop(errch chan error) {
	lua := redislua.NewScript(`
		local loop_id_key = KEYS[1]

		local loop_id = ARGV[1]
		local report_duration = ARGV[2]

		if redis.call("EXISTS", loop_id_key) > 0 and loop_id ~= redis.call("GET", loop_id_key) then
			return 0
		end
		redis.call("SET", loop_id_key, loop_id, "EX", report_duration + 5)

		return 1
	`)
	keys := []string{"jobworker:record_loop"}
	args := []interface{}{
		r.id,
		int(r.reportDuration / time.Second),
	}

	ticker := time.NewTicker(r.reportDuration)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			result, err := lua.Exec(r.rclient, keys, args...)
			if err != nil {
				errch <- err
				return
			}
			switch val := result.(type) {
			case int64:
				if val == 0 {
					time.Sleep(r.reportDuration)
					continue
				}
			default:
				errch <- errors.New("invalid type")
				return
			}

			current := time.Now().Unix()
			from := strconv.Itoa(int(current) - 4)
			to := strconv.Itoa(int(current))
			counts, err := r.rclient.ZRangeByScore("jobworker:count_history", redis.ZRangeBy{Min: from, Max: to}).Result()
			if err != nil {
				errch <- err
				return
			}
			totalCount := 0
			for _, data := range counts {
				item := strings.Split(data, ",")
				val, err := strconv.Atoi(item[1])
				if err != nil {
					errch <- err
					return
				}
				totalCount += val
			}

			execRate := float64(totalCount) / float64(r.reportDuration/time.Second)
			log.Print("## per seconds:", execRate)
			queSize, err := r.que.Size()
			if err != nil {
				errch <- err
				return
			}

			json, err := json.Marshal(ReportData{ExecRate: execRate, QueSize: int(queSize)})
			if err != nil {
				errch <- err
				return
			}

			r.rclient.LPush("jobworker:report:data", json)
			r.rclient.LTrim("jobworker:report:data", 0, 49)
		}
	}
}
