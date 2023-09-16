package confutil_test

import (
	"testing"

	"github.com/mrk21/sandbox/go-config/pkg/confutil"
)

var isTestEnvBeforeBootingTest = confutil.IsTestEnv()

func TestIsTestEnv(t *testing.T) {
	t.Run("before booting go test", func(t *testing.T) {
		if isTestEnvBeforeBootingTest {
			t.Error("confutil.IsTestEnv() should be false")
		}
	})

	t.Run("after booting go test", func(t *testing.T) {
		if !confutil.IsTestEnv() {
			t.Error("confutil.IsTestEnv() should be true")
		}
	})
}
