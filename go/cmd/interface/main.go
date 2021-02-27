package main

import (
	"fmt"
	"strconv"
)

type StringConvertable interface {
	ToString() string
}

type HogeType struct {
	value int
}

func (h * HogeType) ToString() string {
	return strconv.Itoa(h.value)
}

func Inspect(o StringConvertable) {
	fmt.Println(o.ToString())
}

func main() {
	hoge := &HogeType{12}
	Inspect(hoge)
}
