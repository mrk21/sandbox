package main

import (
	"log"
	"os"

	"github.com/go-redis/redis"
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
		PoolSize: 100,
	})
	w := worker.New(rclient)
	err := w.Run()
	if err != nil {
		log.Panic(err)
	}
}
