package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"strings"

	"github.com/elazarl/goproxy"
)

func ParseCIDR(cidr string) *net.IPNet {
	_, ipnet, err := net.ParseCIDR(cidr)
	if err != nil {
		panic("Invalid CIDR: " + cidr)
	}
	return ipnet
}

func ResolveIP(addr string) net.IP {
	resolvedAddr, err := net.ResolveTCPAddr("tcp", addr+":80")
	if err != nil {
		panic("Invalid addr: " + addr)
	}
	return resolvedAddr.IP
}

var denyDestCIDRs = []*net.IPNet{
	ParseCIDR("127.0.0.0/8"),    // RFC 3333 loop back address
	ParseCIDR("10.0.0.0/8"),     // RFC 1918 possible internal network
	ParseCIDR("172.16.0.0/12"),  // RFC 1918 possible internal network
	ParseCIDR("192.168.0.0/16"), // RFC 1918 possible internal network
	ParseCIDR("169.254.0.0/16"), // RFC 3927 link-local address
	ParseCIDR("::1/128"),        // RFC 4291 loop back address
	ParseCIDR("fc00::/7"),       // RFC 4193 local private network range
	ParseCIDR("fe80::/10"),      // RFC 4291 link-local (directly plugged) machines
}

var allowSrcIPs = []net.IP{
	ResolveIP("client"), // IP of `client` docker container
}

func IsAllowedDestIP(ip net.IP) bool {
	for _, denyCIDR := range denyDestCIDRs {
		if denyCIDR.Contains(ip) {
			return false
		}
	}
	return true
}

func IsAllowedSrcIP(ip net.IP) bool {
	for _, allowIP := range allowSrcIPs {
		if allowIP.Equal(ip) {
			return true
		}
	}
	return false
}

func main() {
	var rejectCondition goproxy.ReqConditionFunc = func(req *http.Request, ctx *goproxy.ProxyCtx) bool {
		srcAddr, err := net.ResolveTCPAddr("tcp", req.RemoteAddr)
		if err != nil {
			log.Fatal(err)
			return true
		}
		fmt.Println("## Src IP:", srcAddr.IP)

		dest := req.Host
		if !strings.Contains(dest, ":") {
			dest += ":80"
		}
		destAddr, err := net.ResolveTCPAddr("tcp", dest)
		if err != nil {
			log.Fatal(err)
			return true
		}
		fmt.Println("## Dest IP:", destAddr.IP)

		return !IsAllowedSrcIP(srcAddr.IP) || !IsAllowedDestIP(destAddr.IP)
	}

	alwaysReject := func(req *http.Request, ctx *goproxy.ProxyCtx) (*http.Request, *http.Response) {
		log.Println("##", "Reject")
		resp := goproxy.NewResponse(
			req,
			"plan/text",
			http.StatusForbidden,
			"reject",
		)
		return req, resp
	}

	proxy := goproxy.NewProxyHttpServer()
	proxy.Verbose = true
	proxy.OnRequest(rejectCondition).DoFunc(alwaysReject)
	proxy.OnRequest(rejectCondition).HandleConnect(goproxy.AlwaysReject)

	log.Fatal(http.ListenAndServe(":8080", proxy))
}
