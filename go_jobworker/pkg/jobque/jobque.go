package jobque

import (
	"encoding/json"
	"time"

	"github.com/go-redis/redis"
)

type JobQueue struct {
	rclient *redis.Client
}

type Item struct {
	Url string `json:"url"`
}

func New(rclient *redis.Client) *JobQueue {
	return &JobQueue{
		rclient: rclient,
	}
}

func (q *JobQueue) Size() (int, error) {
	data, err := q.rclient.LLen("jobworker:queue").Result()
	return int(data), err
}

func (q *JobQueue) Enqueue(item Item) error {
	data, err := json.Marshal(item)
	if err != nil {
		return err
	}
	_, err = q.rclient.LPush("jobworker:queue", data).Result()
	if err != nil {
		return err
	}
	return nil
}

func (q *JobQueue) Dequeue(n int, timeout time.Duration) ([]*Item, error) {
	cmds := []*redis.StringCmd{}
	pipe := q.rclient.TxPipeline()
	for i := 0; i < n; i++ {
		cmds = append(cmds, q.rclient.RPop("jobworker:queue"))
	}
	_, err := pipe.Exec()
	if err != nil {
		return nil, err
	}

	results := []string{}
	for _, cmd := range cmds {
		data, err := cmd.Result()
		if err == redis.Nil {
			continue
		} else if err != nil {
			return nil, err
		}
		results = append(results, data)
	}

	if len(results) == 0 {
		data, err := q.rclient.BRPop(timeout, "jobworker:queue").Result()
		if err == redis.Nil {
			return nil, nil
		} else if err != nil {
			return nil, err
		}
		results = append(results, data[1])
	}

	items := []*Item{}
	for _, result := range results {
		item := &Item{}
		err := json.Unmarshal([]byte(result), item)
		if err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	return items, nil
}
