package worker

import (
	"log"
	"time"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/counter"
	"github.com/mrk21/sandbox/go_jobworker/pkg/job"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
	"github.com/mrk21/sandbox/go_jobworker/pkg/reporter"
)

type Worker struct {
	rclient  *redis.Client
	que      *jobque.JobQueue
	counter  *counter.Counter
	reporter *reporter.Reporter
	job      job.Job
}

func New(rclient *redis.Client, job job.Job) (*Worker, error) {
	q := jobque.New(rclient)
	c, err := counter.New(rclient, q, 500, time.Second)
	if err != nil {
		return nil, err
	}
	r, err := reporter.New(rclient, q, time.Second*5)
	if err != nil {
		return nil, err
	}
	w := &Worker{
		rclient:  rclient,
		que:      q,
		counter:  c,
		reporter: r,
		job:      job,
	}
	return w, nil
}

func (w *Worker) Run() error {
	go w.counter.ResetLoop()
	go w.reporter.RecordLoop()

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
			ok, err := w.counter.Call(func() { go w.execute(item) })
			if err != nil {
				return err
			}
			if !ok {
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

	err := w.job.Perform(item)
	if err != nil {
		log.Println("job failed", item, err)
		return
	}
}
