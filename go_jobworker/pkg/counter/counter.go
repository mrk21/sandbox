package counter

import (
	"errors"
	"fmt"
	"log"
	"net"
	"time"

	"github.com/go-redis/redis"
	"github.com/google/uuid"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
	"github.com/mrk21/sandbox/go_jobworker/pkg/redislua"
)

type Counter struct {
	rclient       *redis.Client
	que           *jobque.JobQueue
	limit         int
	limitDuration time.Duration
	id            string
}

func New(rclient *redis.Client, que *jobque.JobQueue, limit int, limitDuration time.Duration) (*Counter, error) {
	uuid, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}
	c := &Counter{
		rclient:       rclient,
		que:           que,
		limit:         limit,
		limitDuration: limitDuration,
		id:            uuid.String(),
	}
	return c, nil
}

func (c *Counter) WaitUnlock() (ret error) {
	_, err := c.rclient.ConfigSet("notify-keyspace-events", "KEA").Result()
	if err != nil {
		return err
	}
	ch := fmt.Sprintf("__keyspace@%d__:jobworker:lock", c.rclient.Options().DB)
	pubsub := c.rclient.PSubscribe(ch)
	defer pubsub.Close()

	for {
		msgi, err := pubsub.ReceiveTimeout(c.limitDuration)
		if err != nil {
			switch err.(type) {
			case *net.OpError: // Timeout
				log.Print("Timeout: ", err)
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

func (c *Counter) ResetLoop(errch chan error) {
	lua := redislua.NewScript(`
		local loop_id_key = KEYS[1]
		local lock_key = KEYS[2]
		local count_key = KEYS[3]
		local report_count_key = KEYS[4]

		local loop_id = ARGV[1]
		local limit_duration = ARGV[2]

		if redis.call("EXISTS", loop_id_key) > 0 and loop_id ~= redis.call("GET", loop_id_key) then
			return 0
		end
		redis.call("SET", loop_id_key, loop_id, "EX", limit_duration + 5)

		local count = tonumber(redis.call("GETSET", count_key, 0))
		redis.call("INCRBY", report_count_key, count)
		redis.call("DEL", lock_key)

		return 1
	`)
	keys := []string{
		"jobworker:reset_loop",
		"jobworker:lock",
		"jobworker:count",
		"jobworker:report:count",
	}
	args := []interface{}{
		c.id,
		int(c.limitDuration / time.Second),
	}

	ticker := time.NewTicker(c.limitDuration)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			_, err := lua.Exec(c.rclient, keys, args...)
			if err != nil {
				errch <- err
				return
			}
		}
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

// Calls the callback if the counter value less than the limit
func (c *Counter) Call(callback func()) (bool, error) {
	lua := redislua.NewScript(`
		local count_key = KEYS[1]
		local lock_key = KEYS[2]
		local limit = tonumber(ARGV[1])
		local limit_duration = tonumber(ARGV[2])
		local value = tonumber(redis.call("GET", count_key))
		if value >= limit then
			redis.call("SET", lock_key, 1, "EX", limit_duration)
			return 1
		else
			redis.call("INCR", count_key)
			return 0
		end
	`)
	keys := []string{
		"jobworker:count",
		"jobworker:lock",
	}
	args := []interface{}{
		c.limit,
		int(c.limitDuration / time.Second),
	}
	result, err := lua.Exec(c.rclient, keys, args...)
	if err != nil {
		return false, err
	}
	switch val := result.(type) {
	case int64:
		if val == 0 {
			callback()
			return true, nil
		}
	default:
		return false, errors.New("invalid type")
	}
	return false, nil
}
