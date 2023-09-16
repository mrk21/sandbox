package confutil

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"text/template"

	"github.com/mrk21/sandbox/go-config/pkg/genutil"
)

// Template engine notated by [text/template] for YAML files.
type YAMLTemplate struct {
	data map[string]interface{}
}

func NewYAMLTemplate(data map[string]interface{}) *YAMLTemplate {
	if data == nil {
		data = map[string]interface{}{}
	}
	return &YAMLTemplate{
		data: data,
	}
}

func (t *YAMLTemplate) Compile(name string, r io.Reader, w io.Writer) error {
	funcMap := template.FuncMap{
		"env":  t.Env,
		"str":  t.Str,
		"yaml": t.Yaml,
	}
	value, err := io.ReadAll(r)
	if err != nil {
		return err
	}
	tmpl, err := template.New(name).Funcs(funcMap).Parse(string(value))
	if err != nil {
		return err
	}
	err = tmpl.Execute(w, t.data)
	if err != nil {
		return err
	}
	return nil
}

// Get an environment variable specified by `key`. When this value is empty, it returns the first non-zero value specified by `defaultValues`.
//
//	os.Setenv("A", "1")
//
//	a: {{ env "A" }}                 #=> a: 1
//	b: {{ env "B" "val" }}           #=> b: val
//	c: {{ env "C" (env "D") "val" }} #=> c: val
func (t *YAMLTemplate) Env(key string, defaultValues ...string) string {
	val := os.Getenv(key)
	if val == "" {
		values := genutil.Compact(defaultValues)
		if len(values) == 0 {
			return ""
		}
		return values[0]
	}
	return val
}

// Transform a specified value to a string value.
//
//	data := map[string]interface{}{
//		"hoge": map[string]interface{}{
//			"key1": "value1",
//			"key2": "value2",
//		}
//	}
//
//	a: {{ .hoge.key1 | str }} #=> a: value1
//	b: {{ .hoge.key3 | str }} #=> b:
func (t *YAMLTemplate) Str(value interface{}) string {
	if value == nil {
		return ""
	}
	return fmt.Sprint(value)
}

// Transform a specified value to a YAML value.
//
//	data := map[string]interface{}{
//		"hoge": map[string]interface{}{
//			"key1": "value1",
//			"key2": "value2",
//		}
//	}
//
//	a: {{ .hoge.key1 | yaml }} #=> a: "value1"
//	b: {{ .hoge.key3 | yaml }} #=> b: null
//	c: {{ .hoge | yaml }} #=> c: {"key1":"value1","key2":"value2"}
//
// NOTE: YAML is upward compatible to JSON, so if you output an object to JSON, YAML parser interprets it as YAML map or list.
func (t *YAMLTemplate) Yaml(value interface{}) string {
	result, err := json.Marshal(value)
	if err != nil {
		panic(err)
	}
	return string(result)
}
