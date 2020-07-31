package main

import (
	"encoding/hex"
	"fmt"
	"net"
)

func main() {
	body := "POST /bar HTTP/1.1\r\n" +
		"Host: hoge.com\r\n" +
		"Content-Length: 9\r\n" +
		"\r\n" +
		"POST body"

	ppv1 := []byte("PROXY TCP4 192.168.33.1 192.168.33.177 35407 80\r\n")
	ppv1WithBody := []byte{}
	ppv1WithBody = append(ppv1WithBody, ppv1...)
	ppv1WithBody = append(ppv1WithBody, []byte(body)...)
	fmt.Printf("## PROXY Protocol v1\n%s\n", hex.Dump(ppv1))
	fmt.Printf("## PROXY Protocol v1 with body\n%s\n", hex.Dump(ppv1WithBody))
	send(ppv1WithBody)

	ppv2 := []byte{0x0D, 0x0A, 0x0D, 0x0A, 0x00, 0x0D, 0x0A, 0x51, 0x55, 0x49, 0x54, 0x0A} // \r\n \r\n \0 \r\n QUIT \n
	ppv2 = append(ppv2, []byte{0x21}...)                                                   // Version 2, PROXY command
	ppv2 = append(ppv2, []byte{0x11}...)                                                   // AF_INET, SOCK_STREAM
	ppv2 = append(ppv2, []byte{0x00, 0x0C}...)                                             // Src/Dst addr/port length
	ppv2 = append(ppv2, []byte{0xC0, 0xA8, 0x64, 0xC8}...)                                 // Src addr: 192.168.100.200
	ppv2 = append(ppv2, []byte{0xC0, 0xA8, 0x64, 0xC9}...)                                 // Dst addr: 192.168.100.201
	ppv2 = append(ppv2, []byte{0xD8, 0x6F}...)                                             // Src port: 55407
	ppv2 = append(ppv2, []byte{0x1F, 0x90}...)                                             // Dst port: 8080

	ppv2WithBody := []byte{}
	ppv2WithBody = append(ppv2WithBody, ppv2...)
	ppv2WithBody = append(ppv2WithBody, []byte(body)...)
	fmt.Printf("## PROXY Protocol v2\n%s\n", hex.Dump(ppv2))
	fmt.Printf("## PROXY Protocol v2 with body\n%s", hex.Dump(ppv2WithBody))
	send(ppv2WithBody)

	send([]byte(body))
}

func send(body []byte) {
	con, err := net.Dial("tcp", "127.0.0.1:8080")

	if err != nil {
		panic(err)
	}

	con.Write(body)
	con.Close()
}
