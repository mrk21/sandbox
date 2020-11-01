package main

import (
	"log"
	"os"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/worker"
)

func main() {
	var rclient *redis.Client = nil
	host := os.Getenv("REDIS_HOST")
	port := os.Getenv("REDIS_PORT")
	pass := os.Getenv("REDIS_PASS")
	rclient = redis.NewClient(&redis.Options{
		Addr:     host + ":" + port,
		Password: pass,
	})
	w := worker.New(rclient)
	err := w.Run()
	if err != nil {
		log.Panic(err)
	}
}
