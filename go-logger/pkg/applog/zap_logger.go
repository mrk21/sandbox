package applog

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

type ZapLogger struct {
	zapLogger *zap.Logger
}

var zapLevelMap = map[Level]zapcore.Level{
	LevelDebug: zap.DebugLevel,
	LevelInfo:  zap.InfoLevel,
	LevelWarn:  zap.WarnLevel,
	LevelError: zap.ErrorLevel,
	LevelPanic: zap.PanicLevel,
}

func NewZapLogger(level Level) (*ZapLogger, error) {
	config := zap.Config{
		OutputPaths:      []string{"stderr"},
		ErrorOutputPaths: []string{"stderr"},
		Level:            zap.NewAtomicLevelAt(zapLevelMap[level]),
		Encoding:         "json",
		Development:      false,
		Sampling: &zap.SamplingConfig{
			Initial:    100,
			Thereafter: 100,
		},
		EncoderConfig: zapcore.EncoderConfig{
			LevelKey:     "level",
			TimeKey:      "time",
			NameKey:      "tags",
			CallerKey:    "caller",
			MessageKey:   "message",
			EncodeTime:   zapcore.TimeEncoderOfLayout(formatISO8601),
			EncodeLevel:  zapcore.CapitalLevelEncoder,
			EncodeCaller: zapcore.ShortCallerEncoder,
		},
	}
	zapLogger, err := config.Build()
	if err != nil {
		return nil, err
	}
	zapLogger = zapLogger.WithOptions(zap.AddCallerSkip(1))
	logger := &ZapLogger{
		zapLogger: zapLogger,
	}
	return logger, nil
}

func (logger *ZapLogger) Debug(v ...interface{}) {
	logger.zapLogger.Sugar().Debug(v...)
}

func (logger *ZapLogger) Info(v ...interface{}) {
	logger.zapLogger.Sugar().Info(v...)
}

func (logger *ZapLogger) Warn(v ...interface{}) {
	logger.zapLogger.Sugar().Warn(v...)
}

func (logger *ZapLogger) Error(v ...interface{}) {
	logger.zapLogger.Sugar().Error(v...)
}

func (logger *ZapLogger) Panic(v ...interface{}) {
	logger.zapLogger.Sugar().Panic(v...)
}

func (logger *ZapLogger) Tagged(tags ...string) Logger {
	zapLogger := logger.zapLogger
	for _, tag := range tags {
		zapLogger = zapLogger.Named(tag)
	}
	newLogger := &ZapLogger{
		zapLogger: zapLogger,
	}
	return newLogger
}

func (logger *ZapLogger) Scope(callback func(Logger)) {
	callback(logger)
}

func (logger *ZapLogger) Destroy() {
	logger.zapLogger.Sync()
}
