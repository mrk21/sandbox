package confutil

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"

	"dario.cat/mergo"
	"gopkg.in/yaml.v3"
)

// Load specified YAML files and generate a config instance.
//
// Load the following order, and merge recursively(1. is required, 2. and later are read if the corresponding file exists):
//
//  1. config.yaml
//  2. config.local.yaml
//  3. config.${env}.yaml
//  4. config.${env}.local.yaml
//
// Each YAML files can use [text/template] notation (see [YAMLTemplate] for details):
//
//	host: {{ env "DB_HOST" "localhost" }}
//
// Also, common data that can be used in each `config.yaml` files can be described in `data.yaml` and `data.local.yaml`,
// and templates can be used as well.
//
// The YAML files are read recursively in the following order:
//
//  1. data.yaml
//  2. data.local.yaml
//
// Those data can be referenced to each `config.yaml` files as follows:
//
// *data.yaml:*
//
//	clone_db:
//		host: https://clone-db
//		port: 3306
//		user: clone_db_user
//		pass: clone_db_pass
//
// *config.yaml:*
//
//	db: {{ .clone_db | yaml }}
//
// You can confirm the final configuration value with the `go run ./cmd/config` command:
//
//	$ go run ./cmd/config
//	{
//	    "DB": {
//	        "Host": "localhost",
//	        ...
//	}
type Loader[C any, E ~string] struct {
	fs fs.FS
}

func NewLoader[C any, E ~string](fs_ fs.FS) *Loader[C, E] {
	return &Loader[C, E]{
		fs: fs_,
	}
}

func (l *Loader[C, E]) Load(env E) (*C, error) {
	data := map[string]interface{}{}
	paths := []string{
		"data.yaml",
		"data.local.yaml",
	}
	for _, p := range paths {
		d, err := l.loadYAML(p, nil)
		if err != nil && !os.IsNotExist(err) {
			return nil, err
		}
		mergo.Merge(&data, &d, mergo.WithOverride)
	}

	conf := map[string]interface{}{}
	{
		c, err := l.loadYAML("config.yaml", data)
		if err != nil {
			return nil, err
		}
		mergo.Merge(&conf, &c, mergo.WithOverride)
	}
	paths = []string{
		"config.local.yaml",
		fmt.Sprintf("config.%s.yaml", env),
		fmt.Sprintf("config.%s.local.yaml", env),
	}
	for _, p := range paths {
		c, err := l.loadYAML(p, data)
		if err != nil && !os.IsNotExist(err) {
			return nil, err
		}
		mergo.Merge(&conf, &c, mergo.WithOverride)
	}

	result := new(C)
	err := l.mapToStruct(conf, result)
	if err != nil {
		return nil, err
	}
	return result, nil
}

func (l *Loader[C, E]) loadYAML(path string, data map[string]interface{}) (map[string]interface{}, error) {
	f, err := l.fs.Open(path)
	if err != nil {
		return nil, err
	}

	w := bytes.NewBuffer([]byte{})
	tmpl := NewYAMLTemplate(data)
	err = tmpl.Compile(path, f, w)
	if err != nil {
		return nil, err
	}

	c := map[string]interface{}{}
	err = yaml.Unmarshal(w.Bytes(), &c)
	if err != nil {
		return nil, err
	}

	return c, nil
}

func (l *Loader[C, E]) mapToStruct(m map[string]interface{}, out *C) error {
	data, err := yaml.Marshal(m)
	if err != nil {
		return err
	}
	err = yaml.Unmarshal(data, out)
	if err != nil {
		return err
	}
	return nil
}
