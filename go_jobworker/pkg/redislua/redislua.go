package redislua

import (
	"crypto/sha1"
	"encoding/hex"
	"strings"

	"github.com/go-redis/redis"
)

type Script struct {
	Script string
	SHA    string
}

func NewScript(script string) *Script {
	hash := sha1.Sum([]byte(script))
	digest := hex.EncodeToString(hash[:])

	return &Script{
		Script: script,
		SHA:    digest,
	}
}

func (s *Script) Exec(rclient *redis.Client, keys []string, args ...interface{}) (interface{}, error) {
	result, err := rclient.EvalSha(s.SHA, keys, args...).Result()
	if err == nil {
		return result, nil
	} else if !strings.Contains(err.Error(), "NOSCRIPT") {
		return nil, err
	}

	result, err = rclient.Eval(s.Script, keys, args...).Result()
	if err != nil {
		return nil, err
	}
	return result, nil
}
