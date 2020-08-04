package main

import (
	"fmt"

	"golang.org/x/crypto/bcrypt"
)

func main() {
	rawPassword := "mypassword1234!"
	hashedPassword := hashPassword(rawPassword)
	fmt.Println(auth(rawPassword, hashedPassword))
	fmt.Println(auth("pass", hashedPassword))
}

func hashPassword(rawPassword string) string {
	fmt.Println("## Raw password:", rawPassword)
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(rawPassword), bcrypt.DefaultCost)
	if err != nil {
		panic(err)
	}
	fmt.Println("## Hashed password:", string(hashedPassword))
	return string(hashedPassword)
}

func auth(inputPassword string, hashedPassword string) bool {
	fmt.Println("## Input password:", inputPassword)
	err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(inputPassword))
	if err != nil {
		fmt.Printf("Wrong password: %!s(MISSING)", err)
		return false
	}
	return true
}
