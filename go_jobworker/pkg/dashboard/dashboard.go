package dashboard

import (
	"encoding/json"
	"html/template"
	"log"
	"net/http"

	"github.com/go-redis/redis"
	"github.com/mrk21/sandbox/go_jobworker/pkg/counter"
	"github.com/mrk21/sandbox/go_jobworker/pkg/httpsrv"
	"github.com/mrk21/sandbox/go_jobworker/pkg/jobque"
)

type Dashboard struct {
	rclient *redis.Client
	srv     *httpsrv.HTTPServer
}

func New(rclient *redis.Client, port string) *Dashboard {
	d := &Dashboard{
		rclient: rclient,
		srv:     httpsrv.New(":" + port),
	}
	d.srv.AddRoute("GET", "/", d.html)
	d.srv.AddRoute("GET", "/api", d.api)
	d.srv.BuildHandlers()
	return d
}

func (d *Dashboard) Start() {
	d.srv.Serve()
}

func (d *Dashboard) html(w http.ResponseWriter, req *http.Request) {
	w.WriteHeader(http.StatusOK)
	t, err := template.New("index.html").Delims("[[", "]]").ParseFiles("pkg/dashboard/index.html")
	if err != nil {
		log.Printf("template error: %v", err)
	}
	err = t.Execute(w, struct{}{})
	if err != nil {
		log.Printf("failed to execute template: %v", err)
	}
}

func (d *Dashboard) api(w http.ResponseWriter, req *http.Request) {
	data := counter.New(d.rclient, jobque.New(d.rclient), 1)
	data_, _ := data.Report()
	json, _ := json.Marshal(data_)
	w.WriteHeader(http.StatusOK)
	w.Write(json)
}
