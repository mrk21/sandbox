package applog

// Time format must be ISO 8601 with microseconds
type Logger interface {
	Debug(v ...interface{})
	Info(v ...interface{})
	Warn(v ...interface{})
	Error(v ...interface{})
	Panic(v ...interface{})       // Must call panic()
	Tagged(tags ...string) Logger // Tagged method must be thread-safe and immutable
	Scope(callback func(Logger))
	Destroy()
}

type Level int

const (
	LevelDebug Level = iota
	LevelInfo  Level = iota
	LevelWarn  Level = iota
	LevelError Level = iota
	LevelPanic Level = iota
)

const formatISO8601 = "2006-01-02T15:04:05.000000Z0700"
