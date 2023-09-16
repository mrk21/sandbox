package confutil

import (
	"io/fs"
	"sync"
)

// Loader for global config. An instance of this type is usually used by global variables.
//
// If you want to load config files easually, define the following codes in the config directory(e.g. config/config.go):
//
//	// Types
//	type Config struct {
//		Hoge string `yaml:"hoge"`
//	}
//
//	// Files
//	//go:embed *.yaml
//	var Files embed.FS
//
//	// Envs
//	type Env string
//	const (
//		EnvTest Env = "test"
//		EnvDev  Env = "dev"
//		EnvStg  Env = "stg"
//		EnvProd Env = "prod"
//	)
//	func CurrentEnv() Env {
//		if confutil.IsTestEnv() { return EnvTest }
//		env := os.Getenv("ENV")
//		if env == "" { return EnvDev }
//		return Env(env)
//	}
//
//	// Loader
//	var globalLoader = confutil.NewGlobalLoader[Config](Files, CurrentEnv)
//	func Load() error  { return globalLoader.Load() }
//	func Get() *Config { return globalLoader.Get() }
type GlobalLoader[C any, E ~string] struct {
	loader        *Loader[C, E]
	getCurrentEnv func() E
	conf          *C
	mu            sync.Mutex
}

func NewGlobalLoader[C any, E ~string](fs_ fs.FS, getCurrentEnv func() E) *GlobalLoader[C, E] {
	return &GlobalLoader[C, E]{
		loader:        NewLoader[C, E](fs_),
		getCurrentEnv: getCurrentEnv,
	}
}

func (gl *GlobalLoader[C, E]) Load() error {
	defer gl.mu.Unlock()
	gl.mu.Lock()

	env := gl.getCurrentEnv()
	conf, err := gl.loader.Load(env)
	if err != nil {
		return err
	}
	gl.conf = conf

	return nil
}

func (gl *GlobalLoader[C, E]) Get() *C {
	if gl.conf == nil {
		err := gl.Load()
		if err != nil {
			panic(err)
		}
	}
	return gl.conf
}
