package main

import (
	"log"

	"github.com/mrk21/sandbox/go-logger/pkg/applog"
)

func main() {
	{
		logger := applog.NewStdLogger(applog.LevelInfo)
		defer logger.Destroy()
		logging(logger)
	}
	{
		logger, err := applog.NewZapLogger(applog.LevelInfo)
		if err != nil {
			panic(err)
		}
		defer logger.Destroy()
		logging(logger)
	}
}

func logging(logger applog.Logger) {
	defer func() {
		if err := recover(); err != nil {
			log.Print(err)
		}
	}()
	logger.Info("ddd")
	logger.Debug("debug")
	logger.Warn("ddd", "aaa", 1, 2)

	logger.Tagged("Server").Scope(func(logger applog.Logger) {
		logger.Info("hoge")
		logger.Tagged("Foo").Warn("hoge")
		logger.Error("error")
	})
	logger.Panic("panic")
	logger.Info("info")
}
