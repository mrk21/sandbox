package main

import (
	"log"
	"math/rand"
	"os"
	"strconv"
	"time"

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
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 100000; i++ {
		value := rand.Intn(100)
		url := "http://127.0.0.1:2000/api?value=" + strconv.Itoa(value)
		err := que.Enqueue(jobque.Item{Url: url})
		if err != nil {
			log.Panic(err)
		}
	}
}
