package httpsrv

import (
	"net"
	"net/http"
)

type HTTPServer struct {
	addr     string
	mux      *http.ServeMux
	handlers map[string]map[string]http.HandlerFunc
}

func New(addr string) *HTTPServer {
	srv := &HTTPServer{
		addr:     addr,
		mux:      http.NewServeMux(),
		handlers: map[string]map[string]http.HandlerFunc{},
	}
	return srv
}

func (srv *HTTPServer) Serve() error {
	listener, err := net.Listen("tcp", srv.addr)
	if err != nil {
		return err
	}
	defer listener.Close()

	server := http.Server{Addr: srv.addr, Handler: srv.mux}
	server.Serve(listener)
	return nil
}

func (srv *HTTPServer) AddRoute(method string, path string, handler http.HandlerFunc) {
	if srv.handlers[path] == nil {
		srv.handlers[path] = map[string]http.HandlerFunc{}
	}
	srv.handlers[path][method] = handler
}

func (srv *HTTPServer) BuildHandlers() {
	for path, methods := range srv.handlers {
		p := path
		m := methods
		srv.mux.Handle(p, http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
			if m[req.Method] != nil {
				m[req.Method](w, req)
			} else {
				w.WriteHeader(http.StatusNotFound)
				w.Write([]byte("Not Found"))
			}
		}))
	}
}
