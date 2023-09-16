package config

import (
	"embed"
	"os"

	"github.com/mrk21/sandbox/go-config/pkg/confutil"
)

// Types
type Config struct {
	DB *ConfigDB `yaml:"db"`
}

type ConfigDB struct {
	Host string `yaml:"host"`
	PORT int    `yaml:"port"`
	User string `yaml:"user"`
	Pass string `yaml:"pass"`
}

// Files
//
//go:embed *.yaml
var Files embed.FS

// Envs
type Env string

const (
	EnvTest Env = "test"
	EnvDev  Env = "dev"
	EnvStg  Env = "stg"
	EnvProd Env = "prod"
)

func CurrentEnv() Env {
	if confutil.IsTestEnv() {
		return EnvTest
	}
	env := os.Getenv("ENV")
	if env == "" {
		return EnvDev
	}
	return Env(env)
}

// Loader
var globalLoader = confutil.NewGlobalLoader[Config](Files, CurrentEnv)

func Load() error  { return globalLoader.Load() }
func Get() *Config { return globalLoader.Get() }
