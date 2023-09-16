package confutil_test

import (
	"bytes"
	"os"
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/mrk21/sandbox/go-config/pkg/confutil"
	"gopkg.in/yaml.v3"
)

func TestYAMLTemplate_Env(t *testing.T) {
	doTest := func(env string, templ string, expected string) {
		os.Setenv("_TEST_ENV", env)
		defer os.Setenv("_TEST_ENV", "")

		r := bytes.NewBufferString(templ)
		w := bytes.NewBufferString(``)
		tmpl := confutil.NewYAMLTemplate(nil)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		if w.String() != expected {
			t.Error(w.String())
		}
	}

	t.Run("env is found", func(t *testing.T) {
		doTest("1", `a: {{ env "_TEST_ENV" }}`, `a: 1`)

		t.Run("with default value", func(t *testing.T) {
			doTest("1", `a: {{ env "_TEST_ENV" "default" }}`, `a: 1`)
		})

		t.Run("with multiple default values", func(t *testing.T) {
			doTest("1", `a: {{ env "_TEST_ENV" "" "default-2" "default-3" }}`, `a: 1`)
		})
	})

	t.Run("env is not found", func(t *testing.T) {
		doTest("", `a: {{ env "_TEST_ENV" }}`, `a: `)

		t.Run("with default value", func(t *testing.T) {
			doTest("", `a: {{ env "_TEST_ENV" "default" }}`, `a: default`)
		})

		t.Run("with multiple default values", func(t *testing.T) {
			doTest("", `a: {{ env "_TEST_ENV" "" "default-2" "default-3" }}`, `a: default-2`)
		})
	})
}

func TestYAMLTemplate_Str(t *testing.T) {
	tmpl := confutil.NewYAMLTemplate(map[string]interface{}{
		"hoge": map[string]interface{}{
			"key1": "value1",
			"key2": "value2",
		},
	})

	{
		r := bytes.NewBufferString(`a: {{ .hoge.key1 | str }}`)
		w := bytes.NewBufferString(``)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		if w.String() != `a: value1` {
			t.Error(w.String())
		}
	}
	{
		r := bytes.NewBufferString(`a: {{ .hoge.key3 | str }}`)
		w := bytes.NewBufferString(``)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		if w.String() != `a: ` {
			t.Error(w.String())
		}
	}
}

func TestYAMLTemplate_Yaml(t *testing.T) {
	tmpl := confutil.NewYAMLTemplate(map[string]interface{}{
		"hoge": map[string]interface{}{
			"key1": "value1",
			"key2": "value2",
		},
	})

	{
		r := bytes.NewBufferString(`a: {{ .hoge.key1 | yaml }}`)
		w := bytes.NewBufferString(``)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		if w.String() != `a: "value1"` {
			t.Error(w.String())
		}
	}
	{
		r := bytes.NewBufferString(`a: {{ .hoge.key3 | yaml }}`)
		w := bytes.NewBufferString(``)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		if w.String() != `a: null` {
			t.Error(w.String())
		}
	}
	{
		r := bytes.NewBufferString(`a: {{ .hoge | yaml }}`)
		w := bytes.NewBufferString(``)
		err := tmpl.Compile("main", r, w)
		if err != nil {
			t.Error(err)
		}
		expected := `a: {"key1":"value1","key2":"value2"}`
		if w.String() != expected {
			t.Error(w.String())
		}

		result := map[string]interface{}{}
		err = yaml.Unmarshal([]byte(expected), &result)
		if err != nil {
			t.Error(err)
		}

		diff := cmp.Diff(result, map[string]interface{}{
			"a": map[string]interface{}{
				"key1": "value1",
				"key2": "value2",
			},
		})
		if diff != "" {
			t.Error(diff)
		}
	}
}
