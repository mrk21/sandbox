package confutil

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
)

// Get whether to run `go test`
//
// See: https://qiita.com/chimatter/items/6922e7bd34483a9108b1
func IsTestEnv() bool {
	return flag.Lookup("test.v") != nil
}

// Output specified config to JSON
func Output[T any](writer io.Writer, conf *T, isPretty bool) error {
	buf := bytes.NewBuffer([]byte{})
	enc := json.NewEncoder(buf)
	if isPretty {
		enc.SetIndent("", "    ")
	}
	err := enc.Encode(conf)
	if err != nil {
		return err
	}
	_, err = fmt.Fprint(writer, buf.String())
	return err
}
