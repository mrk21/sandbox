package main

import (
	"log"
	"net"

	"github.com/pires/go-proxyproto"
)

func main() {
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
		}()
	}
}
