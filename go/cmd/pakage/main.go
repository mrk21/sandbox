package main

import (
	"fmt"

	"./testpkg"
)

func main() {
	testpkg.Foo()
	testpkg.Bar()
	// testpkg.privateFoo() // Error

	hoge := testpkg.NewHoge()
	// fmt.Println(hoge.privateValue) // Error
	fmt.Println(hoge.Value)
	hoge.Method() // OK
	// hoge.privateMethod() // Error
}
