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
	rclient     *redis.Client
	que         *jobque.JobQueue
	counter     *counter.Counter
	reporter    *reporter.Reporter
	concurrency int
	job         job.Job
}

func New(
	rclient *redis.Client,
	job job.Job,
	limit int,
	concurrency int,
) (*Worker, error) {
	q := jobque.New(rclient)
	c, err := counter.New(rclient, q, limit, time.Second)
	if err != nil {
		return nil, err
	}
	r, err := reporter.New(rclient, q, time.Second*5)
	if err != nil {
		return nil, err
	}
	w := &Worker{
		rclient:     rclient,
		que:         q,
		counter:     c,
		reporter:    r,
		concurrency: concurrency,
		job:         job,
	}
	return w, nil
}

func (w *Worker) Run() error {
	ch := make(chan struct{}, w.concurrency)
	errch := make(chan error)

	go w.reporter.RecordLoop(errch)
	go w.counter.ResetLoop(errch)

	for i := 0; i < w.concurrency; i++ {
		go w.pool(ch, errch)
		ch <- struct{}{}
	}

	select {
	case err := <-errch:
		return err
	}
}

func (w *Worker) pool(ch chan struct{}, errch chan error) {
	c := 100
	for {
		select {
		case <-ch:
			if w.counter.IsReached() {
				err := w.counter.WaitUnlock()
				if err != nil {
					errch <- err
					return
				}
			}

			items, err := w.que.Dequeue(c, time.Second*60)
			if err != nil {
				errch <- err
				return
			} else if items == nil {
				log.Print("no data")
				ch <- struct{}{}
				continue
			}

			for _, item := range items {
				ok, err := w.counter.Call(func() { go w.execute(item) })
				if err != nil {
					errch <- err
					return
				}
				if !ok {
					w.que.Enqueue(*item)
				}
			}
			ch <- struct{}{}
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
