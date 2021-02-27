package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"

	"github.com/imdario/mergo"
)

type Config struct {
	Value1 string `json:"value1"`
	Value2 int    `json:"value2"`
	Value3 string `json:"value3"`
	Map1   struct {
		Key1 int `json:"key1"`
		Key2 int `json:"key2"`
		Key3 int `json:"key3"`
		Key4 int `json:"key4"`
	} `json:"map1"`
	Arr1 []int `json:"arr1"`
}

func main() {
	{
		c := Config{}
		c1 := Config{Value1: "hoge", Value2: 1}
		c2 := Config{Value2: 0}
		mergo.Merge(&c, &c1, mergo.WithOverride)
		mergo.Merge(&c, &c2, mergo.WithOverride)
		fmt.Println(c) // {hoge 1  {0 0 0 0} []}
	}
	{
		c := map[string]interface{}{
			"value3": "default value",
		}
		c1, err := loadConfig("./cmd/mergo/config1.json")
		if err != nil {
			panic(err)
		}
		fmt.Println(c1) // map[arr1:[1 2 3] map1:map[key1:1 key2:2 key3:3] value1:v1 value2:1]

		c2, err := loadConfig("./cmd/mergo/config2.json")
		if err != nil {
			panic(err)
		}
		fmt.Println(c2) // map[arr1:[3 4] map1:map[key1:11 key2:22 key4:44] value2:0]

		mergo.Merge(&c, &c1, mergo.WithOverride)
		mergo.Merge(&c, &c2, mergo.WithOverride)
		fmt.Println(c) // map[arr1:[3 4] map1:map[key1:11 key2:22 key3:3 key4:44] value1:v1 value2:0 value3:default value]

		cfg := Config{}
		err = mapToStruct(c, &cfg)
		if err != nil {
			panic(err)
		}
		fmt.Println(cfg) // {v1 0 default value {11 22 3 44} [3 4]}
	}
}

func loadConfig(path string) (map[string]interface{}, error) {
	c := map[string]interface{}{}
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}
	err = json.Unmarshal(bytes, &c)
	if err != nil {
		return nil, err
	}
	return c, nil
}

func mapToStruct(m map[string]interface{}, out interface{}) error {
	bytes, err := json.Marshal(m)
	if err != nil {
		return err
	}
	err = json.Unmarshal(bytes, out)
	if err != nil {
		return err
	}
	return nil
}
