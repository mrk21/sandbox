package main

import "fmt"

type Hoge struct {
	value1 int
	value2 string
}

func (hoge Hoge) Display() {
	fmt.Println(hoge.value1)
	fmt.Println(hoge.value2)
}

func main() {
	hoge := Hoge{1, "a"}
	hoge.Display()
}
