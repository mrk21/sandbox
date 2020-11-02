package main

import (
	"log"
	"os"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
)

func main() {
	var rclient *redis.Client = nil
	host := os.Getenv("REDIS_HOST")
	port := os.Getenv("REDIS_PORT")
	pass := os.Getenv("REDIS_PASS")
	rclient = redis.NewClient(&redis.Options{
		Addr:     host + ":" + port,
		Password: pass,
		PoolSize: 100,
	})
	que := jobque.New(rclient)
	for i := 0; i < 100000; i++ {
		err := que.Enqueue(jobque.Item{Url: "https://localhost.local/foo/bar"})
		if err != nil {
			log.Panic(err)
		}
	}
}
