package main

import (
	"github.com/mrk21/sandbox/go_jobworker/pkg/api"
)

func main() {
	srv := api.New("2000")
	srv.Start()
}
