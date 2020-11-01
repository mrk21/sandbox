package counter

import (
	"encoding/json"
	"log"
	"net"
	"strconv"
	"time"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
)

type Counter struct {
	rclient       *redis.Client
	que           *jobque.JobQueue
	interval      time.Duration
	limit         int
	limitDuration time.Duration
}

func New(rclient *redis.Client, que *jobque.JobQueue, interval time.Duration) *Counter {
	return &Counter{
		rclient:       rclient,
		que:           que,
		interval:      interval,
		limit:         1000,
		limitDuration: time.Second * 1,
	}
}

func (c *Counter) WaitUnlock() (ret error) {
	_, err := c.rclient.ConfigSet("notify-keyspace-events", "KEA").Result()
	if err != nil {
		return err
	}

	pubsub := c.rclient.PSubscribe("__keyspace@0__:jobworker:lock")
	defer pubsub.Close()

	for {
		msgi, err := pubsub.ReceiveTimeout(c.limitDuration)
		if err != nil {
			switch err.(type) {
			case *net.OpError: // Timeout
				log.Print(err)
				return nil
			default:
				return err
			}
		}
		switch msg := msgi.(type) {
		case *redis.Message:
			if msg.Payload == "del" || msg.Payload == "expired" {
				return nil
			}
		}
	}
}

type ReportData struct {
	ExecRate float64 `json:"execRate"`
	QueSize  int     `json:"queSize"`
}

func (c *Counter) Report() ([]ReportData, error) {
	data, err := c.rclient.LRange("jobworker:report:data", 0, 49).Result()
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

func (c *Counter) ReportLoop() {
	for {
		func() {
			data, err := c.rclient.GetSet("jobworker:report:count", 0).Result()
			if err == redis.Nil {
				return
			} else if err != nil {
				log.Print(err)
				return
			}
			count, err := strconv.Atoi(data)
			if err != nil {
				log.Print(err)
				return
			}
			execRate := float64(count) / float64(c.interval)
			log.Print("## per seconds:", execRate)
			queSize, _ := c.que.Size()

			json, _ := json.Marshal(ReportData{ExecRate: execRate, QueSize: int(queSize)})
			c.rclient.LPush("jobworker:report:data", json)
			c.rclient.LTrim("jobworker:report:data", 0, 49)
		}()
		time.Sleep(time.Second * c.interval)
	}
}

func (c *Counter) ResetLoop() {
	for {
		func() {
			_, err := c.rclient.Del("jobworker:lock").Result()
			if err != nil {
				log.Print(err)
				return
			}

			data, err := c.rclient.GetSet("jobworker:count", 0).Result()
			if err == redis.Nil {
				return
			} else if err != nil {
				log.Print(err)
				return
			}
			count, err := strconv.Atoi(data)
			if err != nil {
				log.Print(err)
				return
			}
			_, err = c.rclient.IncrBy("jobworker:report:count", int64(count)).Result()
			if err != nil {
				log.Print(err)
				return
			}
		}()
		time.Sleep(c.limitDuration)
	}
}

func (c *Counter) IsReached() bool {
	data, err := c.rclient.Exists("jobworker:lock").Result()
	if err != nil {
		log.Print(err)
		return true
	}
	return data != 0
}

func (c *Counter) Call(callback func()) (bool, error) {
	count, err := c.rclient.Incr("jobworker:count").Result()
	if count >= int64(c.limit) {
		_, err := c.rclient.Set("jobworker:lock", 1, c.limitDuration).Result()
		if err != nil {
			return true, err
		}
		return true, nil
	}
	callback()
	return false, err
}
