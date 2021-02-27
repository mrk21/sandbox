package main

import (
	"os"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/dashboard"
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
	srv := dashboard.New(rclient, "5000")
	srv.Start()
}
