package main

import (
	"log"
	"os"
	"runtime"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/job"
	"github.com/mrk21/sandbox/go_jobworker/pkg/worker"

	"net/http"
	_ "net/http/pprof"
)

func main() {
	go func() {
		log.Println(http.ListenAndServe("0.0.0.0:6060", nil))
	}()
	var rclient *redis.Client = nil
	host := os.Getenv("REDIS_HOST")
	port := os.Getenv("REDIS_PORT")
	pass := os.Getenv("REDIS_PASS")
	rclient = redis.NewClient(&redis.Options{
		Addr:     host + ":" + port,
		Password: pass,
		DB:       0,
		PoolSize: 100,
	})
	testJob := job.NewTestJob(&redis.Options{
		Addr:     host + ":" + port,
		Password: pass,
		DB:       1,
		PoolSize: 100,
	})
	w, err := worker.New(rclient, testJob, 5000, runtime.NumCPU())
	if err != nil {
		log.Panic(err)
	}
	err = w.Run()
	if err != nil {
		log.Panic(err)
	}
}
