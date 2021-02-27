package applog

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

type StdLogger struct {
	debug  *log.Logger
	info   *log.Logger
	warn   *log.Logger
	error  *log.Logger
	panic  *log.Logger
	level  Level
	tags   []string
	tagStr string
}

func NewStdLogger(level Level) *StdLogger {
	logger := &StdLogger{}
	logger.debug = log.New(newDefaultWriter(logger, "DEBUG"), "", 0)
	logger.info = log.New(newDefaultWriter(logger, "INFO"), "", 0)
	logger.warn = log.New(newDefaultWriter(logger, "WARN"), "", 0)
	logger.error = log.New(newDefaultWriter(logger, "ERROR"), "", 0)
	logger.panic = log.New(newDefaultWriter(logger, "PANIC"), "", 0)
	logger.level = level
	logger.tags = []string{}
	logger.buildTagStr()
	return logger
}

func (logger *StdLogger) buildTagStr() {
	logger.tagStr = ""
	if len(logger.tags) != 0 {
		logger.tagStr = "[" + strings.Join(logger.tags, "][") + "]"
	}
}

func (logger *StdLogger) Debug(v ...interface{}) {
	if logger.level <= LevelDebug {
		logger.debug.Print(v...)
	}
}

func (logger *StdLogger) Info(v ...interface{}) {
	if logger.level <= LevelInfo {
		logger.info.Print(v...)
	}
}

func (logger *StdLogger) Warn(v ...interface{}) {
	if logger.level <= LevelWarn {
		logger.warn.Print(v...)
	}
}

func (logger *StdLogger) Error(v ...interface{}) {
	if logger.level <= LevelError {
		logger.error.Print(v...)
	}
}

func (logger *StdLogger) Panic(v ...interface{}) {
	if logger.level <= LevelPanic {
		logger.panic.Panic(v...)
	}
}

func (logger *StdLogger) Tagged(tags ...string) Logger {
	newLogger := NewStdLogger(logger.level)
	newLogger.tags = append(append([]string{}, logger.tags...), tags...)
	newLogger.buildTagStr()
	return newLogger
}

func (logger *StdLogger) Scope(callback func(Logger)) {
	callback(logger)
}

func (logger *StdLogger) Destroy() {
	// do nothing
}

type defaultWriter struct {
	logger *StdLogger
	level  string
}

func newDefaultWriter(logger *StdLogger, level string) *defaultWriter {
	w := new(defaultWriter)
	w.level = level
	w.logger = logger
	return w
}

func (w *defaultWriter) Write(bytes []byte) (int, error) {
	t := time.Now().Format(formatISO8601)
	_, file, line, ok := runtime.Caller(4)
	caller := ""
	if ok {
		pwd, err := os.Getwd()
		if err != nil {
			return 0, err
		}
		path, err := filepath.Rel(pwd, file)
		if err != nil {
			return 0, err
		}
		caller = fmt.Sprintf("%s:%d", path, line)
	}
	return fmt.Printf("%s [%s]%s %s (%s)\n", t, w.level, w.logger.tagStr, strings.Trim(string(bytes), "\n"), caller)
}
