package main

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
)

type Config struct {
	Socks struct {
		SocketPath string `yaml:"socketPath"`
		Port       int    `yaml:"port"`
	} `yaml:"socks"`
}

func loadConfig() Config {
	var config Config

	data, err := ioutil.ReadFile("/etc/musig.yml")
	if err != nil {
		panic(err)
	}

	err = yaml.Unmarshal(data, &config)
	if err != nil {
		panic(err)
	}

	return config
}
