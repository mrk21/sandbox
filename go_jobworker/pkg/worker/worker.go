package worker

import (
	"errors"
	"log"
	"math/rand"
	"time"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/counter"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
)

type Worker struct {
	rclient *redis.Client
	que     *jobque.JobQueue
	counter *counter.Counter
}

func New(rclient *redis.Client) *Worker {
	q := jobque.New(rclient)
	c := counter.New(rclient, q, 5)
	w := &Worker{que: q, counter: c}
	return w
}

func (w *Worker) Run() error {
	go w.counter.ReportLoop()
	go w.counter.ResetLoop()

	for {
		if w.counter.IsReached() {
			err := w.counter.WaitUnlock()
			if err != nil {
				return err
			}
		}

		items, err := w.que.Dequeue(100, time.Second*60)
		if err != nil {
			return err
		} else if items == nil {
			log.Print("no data")
			continue
		}

		for _, item := range items {
			reached, err := w.counter.Call(func() { go w.execute(item) })
			if err != nil {
				return err
			}
			if reached {
				w.que.Enqueue(*item)
			}
		}
	}
}

func (w *Worker) execute(item *jobque.Item) {
	defer func() {
		if err := recover(); err != nil {
			log.Println("job failed", item, err)
			return
		}
	}()

	err := testJob(item)
	if err != nil {
		log.Println("job failed", item, err)
		return
	}
}

func testJob(item *jobque.Item) error {
	rand.Seed(time.Now().UnixNano())
	value := rand.Intn(10000)
	if value < 5 {
		panic("fatal")
	} else if value < 10 {
		return errors.New("error")
	}
	return nil
}
