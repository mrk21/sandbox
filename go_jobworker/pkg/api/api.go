package api

import (
	"encoding/json"
	"net/http"

	"github.com/mrk21/sandbox/go_jobworker/pkg/httpsrv"
)

type API struct {
	srv *httpsrv.HTTPServer
}

func New(port string) *API {
	a := &API{
		srv: httpsrv.New(":" + port),
	}
	a.srv.AddRoute("GET", "/api", a.api)
	a.srv.BuildHandlers()
	return a
}

func (a *API) Start() {
	a.srv.Serve()
}

func (a *API) api(w http.ResponseWriter, req *http.Request) {
	q := req.URL.Query()
	var value string
	if q == nil {
		value = ""
	} else {
		value = q.Get("value")
	}
	type Data struct {
		Value string `json:"value"`
	}
	json, _ := json.Marshal(struct {
		Data Data `json:"data"`
	}{
		Data: Data{Value: value},
	})
	w.WriteHeader(http.StatusOK)
	w.Write(json)
}
