package testpkg

import "fmt"

// Error:
//   testpkg/b.go:5:6: privateFoo redeclared in this block
//   	previous declaration at testpkg/a.go:5:6
//
// func privateFoo() {
// 	fmt.Println("privateFoo")
// }

func Bar() {
	fmt.Println("## bar")
	privateFoo() // OK: defined on a.go

	hoge := NewHoge()
	hoge.Method()        // OK
	hoge.privateMethod() // OK

	fmt.Println("-- bar")
}
