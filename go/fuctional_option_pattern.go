package main

import "fmt"

type Config struct {
	timeout    int
	retryCount int
}

type ConfigOption = func(*Config)

func NewConfig(options ...ConfigOption) *Config {
	config := Config{}
	config.timeout = 10
	config.retryCount = 5
	for _, option := range options {
		option(&config)
	}
	return &config
}

func Timeout(value int) ConfigOption {
	return func(c *Config) {
		c.timeout = value
	}
}

func RetryCount(value int) ConfigOption {
	return func(c *Config) {
		c.retryCount = value
	}
}

func main() {
	fmt.Println(NewConfig())                            // &{10 5}
	fmt.Println(NewConfig(Timeout(50)))                 // &{50 5}
	fmt.Println(NewConfig(RetryCount(10), Timeout(50))) // &{50 10}
	fmt.Println(NewConfig(RetryCount(10)))              // &{10 10}
}
