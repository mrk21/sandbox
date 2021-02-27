package main

import (
	"bytes"
	"log"
	"net"
	"net/http"

	"github.com/pires/go-proxyproto"
)

func main() {
	go tcpServer()
	httpServer()
}

func tcpServer() {
	addr := "127.0.0.1:8080"
	list, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatalf("couldn't listen to %q: %q\n", addr, err.Error())
	}

	proxyListener := &proxyproto.Listener{Listener: list}
	defer proxyListener.Close()

	for {
		func() {
			conn, _ := proxyListener.Accept()
			defer conn.Close()

			if conn.LocalAddr() == nil {
				log.Fatal("couldn't retrieve local address")
			}
			log.Printf("local address: %q", conn.LocalAddr().String())

			if conn.RemoteAddr() == nil {
				log.Fatal("couldn't retrieve remote address")
			}
			log.Printf("remote address: %q", conn.RemoteAddr().String())

			conn.Write([]byte("OK\n"))
		}()
	}
}

func httpServer() {
	addr := "127.0.0.1:8081"
	list, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatalf("couldn't listen to %q: %q\n", addr, err.Error())
	}

	proxyListener := &proxyproto.Listener{Listener: list}
	defer proxyListener.Close()

	mux := http.NewServeMux()
	mux.Handle("/", http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		log.Println("###", req.RemoteAddr)

		bufbody := new(bytes.Buffer)
		bufbody.ReadFrom(req.Body)
		body := bufbody.String()
		log.Println(body)

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	}))

	server := http.Server{Addr: addr, Handler: mux}
	server.Serve(proxyListener)
}
