package reporter

import (
	"encoding/json"
	"errors"
	"log"
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
		local total_count_key = KEYS[2]

		local loop_id = ARGV[1]
		local report_duration = ARGV[2]

		if redis.call("EXISTS", loop_id_key) > 0 and loop_id ~= redis.call("GET", loop_id_key) then
			return -1
		end
		redis.call("SET", loop_id_key, loop_id, "EX", report_duration + 5)

		return tonumber(redis.call("GETSET", total_count_key, 0))
	`)
	keys := []string{
		"jobworker:record_loop",
		"jobworker:report:count",
	}
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
			var totalCount int
			switch val := result.(type) {
			case int64:
				if val == -1 {
					time.Sleep(r.reportDuration)
					continue
				} else {
					totalCount = int(val)
				}
			default:
				errch <- errors.New("invalid type")
				return
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
