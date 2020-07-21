package testpkg

import "fmt"

func privateFoo() {
	fmt.Println("privateFoo")
}

func Foo() {
	fmt.Println("## foo")
	privateFoo()

	hoge := NewHoge()
	fmt.Println(hoge.privateValue) // OK
	fmt.Println(hoge.Value)
	hoge.Method()        // OK
	hoge.privateMethod() // OK

	fmt.Println("-- foo")
}

type Hoge struct {
	privateValue int
	Value        int
}

func NewHoge() *Hoge {
	hoge := &Hoge{privateValue: 1, Value: 2}
	return hoge
}

func (h Hoge) Method() {
	fmt.Println("Hoge#Method")
	h.privateMethod() // OK
}

func (h Hoge) privateMethod() {
	fmt.Println("Hoge#privateMethod")
}
