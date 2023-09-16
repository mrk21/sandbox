package main

import (
	"os"

	"github.com/mrk21/sandbox/go-config/config"
	"github.com/mrk21/sandbox/go-config/pkg/confutil"
)

func main() {
	err := confutil.Output(os.Stdout, config.Get(), true)
	if err != nil {
		panic(err)
	}
}
