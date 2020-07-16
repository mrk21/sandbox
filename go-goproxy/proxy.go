package main

import (
	"errors"
	"log"
	"net"
	"net/http"

	"github.com/elazarl/goproxy"
)

func parseCIDR(cidr string) *net.IPNet {
	_, ipnet, err := net.ParseCIDR(cidr)
	if err != nil {
		panic("Invalid CIDR: " + cidr)
	}
	return ipnet
}

func IsAllowedIP(ip net.IP) bool {
	denyCIDRs := []*net.IPNet{
		parseCIDR("127.0.0.0/8"),    // RFC 3333 loop back address
		parseCIDR("10.0.0.0/8"),     // RFC 1918 possible internal network
		parseCIDR("172.16.0.0/12"),  // RFC 1918 possible internal network
		parseCIDR("192.168.0.0/16"), // RFC 1918 possible internal network
		parseCIDR("169.254.0.0/16"), // RFC 3927 link-local address
		parseCIDR("::1/128"),        // RFC 4291 loop back address
		parseCIDR("fc00::/7"),       // RFC 4193 local private network range
		parseCIDR("fe80::/10"),      // RFC 4291 link-local (directly plugged) machines
	}
	for _, cidr := range denyCIDRs {
		if cidr.Contains(ip) {
			return false
		}
	}
	return true
}

func main() {
	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = true

	proxy.Tr.Dial = func(network string, addr string) (net.Conn, error) {
		resolvedAddr, err := net.ResolveTCPAddr("tcp", addr)
		if err != nil {
			return nil, errors.New("Not found!")
		}

		ip := resolvedAddr.IP
		log.Println("##", ip.String())

		if IsAllowedIP(ip) {
			return net.Dial(network, addr)
		} else {
			log.Println("Denied!")
			return nil, errors.New("Denied!")
		}
	}

	log.Fatal(http.ListenAndServe(":8080", proxy))
}
