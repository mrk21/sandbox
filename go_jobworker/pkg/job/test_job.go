package job

import (
	"errors"
	"io/ioutil"
	"math/rand"
	"net/http"
	"time"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
)

type TestJob struct {
	rclient *redis.Client
}

func NewTestJob(opt *redis.Options) *TestJob {
	rclient := redis.NewClient(opt)
	return &TestJob{
		rclient: rclient,
	}
}

func (job *TestJob) Perform(item *jobque.Item) error {
	rand.Seed(time.Now().UnixNano())
	value := rand.Intn(10000)
	if value < 5 {
		panic("fatal")
	} else if value < 10 {
		return errors.New("error")
	}
	resp, err := http.Get(item.Url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	byteArray, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	body := string(byteArray)
	_, err = job.rclient.Set("api:result:"+item.Url, body, time.Minute*1).Result()
	if err != nil {
		return err
	}
	return nil
}
