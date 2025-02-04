package utils

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
)

type Config struct {
	Application struct {
		ConfigUrlTestIp      string `json:"config-url-test-ip"`
		ConfigUrlTestPort    int    `json:"config-url-test-port"`
		ConfigTestTimeoutSec int    `json:"config-test-timeout-sec"`
		ConfigLogging        bool   `json:"config-logging"`
	} `json:"application"`
	Modem struct {
		ConfigUrl             string `json:"config-url"`
		ConfigUser            string `json:"config-user"`
		ConfigPassword        string `json:"config-password"`
		ConfigResetTimeoutMin int    `json:"config-reset-timeout-min"`
	} `json:"modem"`
}

func (currentInstance *Config) Parse() {

	jsonFile, err := os.Open("config.json")

	if err != nil {
		log.Fatal(err)
	}

	defer func(jsonFile *os.File) {
		err := jsonFile.Close()
		if err != nil {
			log.Fatal(err)
		}
	}(jsonFile)

	byteValue, err := ioutil.ReadAll(jsonFile)

	if err != nil {
		log.Fatal(err)
	}

	err = json.Unmarshal(
		byteValue,
		&currentInstance,
	)

	if err != nil {
		log.Fatal(err)
	}

	//Desabilita os logs
	if false == currentInstance.Application.ConfigLogging {
		log.SetOutput(ioutil.Discard)
	}

}
