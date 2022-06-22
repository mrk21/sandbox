package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"net/http/httputil"
	"os"
	"os/exec"
)

func DumpRequest(req *http.Request) {
	value, _ := httputil.DumpRequest(req, true)
	log.Printf("[DEBUG] Request:\n------------------\n%s\n------------------\n", string(value))
}

func DumpResponse(res *http.Response) {
	contentType := res.Header.Get("Content-Type")
	isText := contentType == "application/json" || contentType == "text/html"
	value, _ := httputil.DumpResponse(res, isText)
	valueStr := string(value)
	if !isText {
		valueStr += "[Binary]"
	}
	log.Printf("[DEBUG] Response:\n------------------\n%s\n------------------\n", valueStr)
}

func DumpJSON(jsonStr string) {
	temp_file, _ := ioutil.TempFile(os.TempDir(), "photo-manager-json")
	temp_file.Write([]byte(jsonStr))
	temp_file.Close()
	defer os.Remove(temp_file.Name())
	cmd := exec.Command("bash", "-c", "cat "+temp_file.Name()+" | jq -C")
	out, _ := cmd.Output()
	log.Printf("[DEBUG] Content:\n%s\n", string(out))
}
