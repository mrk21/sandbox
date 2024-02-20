//go:generate tinygo build -o main.wasm -target wasm ./main.go
package main

import (
	"fmt"
	"unsafe"
)

//export add
func add(x, y uint32) uint32 {
	return x + y
}

var buf [1024]byte
var bufSize uint32

//export stringToJS
func stringToJS() uint32 {
	ptr, size := stringToPtr("Sample Str")
	bufSize = size
	return ptr
}

//export getBufSize
func getBufSize() uint32 {
	return bufSize
}

func stringToPtr(s string) (uint32, uint32) {
	buf := []byte(s)
	ptr := &buf[0]
	unsafePtr := uintptr(unsafe.Pointer(ptr))
	return uint32(unsafePtr), uint32(len(buf))
}

//export stringFromJS
func stringFromJS(message string) int {
	return len(message)
}

//export getBuffer
func getBuffer() *byte {
	return &buf[0]
}

func main() {
	fmt.Println("Hello World")
}
