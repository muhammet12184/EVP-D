package main

import (
	"bufio"
	"os"
	"strings"
)

type PID struct {
	Name     string `json:"name"`
	ModePID  string `json:"mode_pid"`
	Equation string `json:"equation"`
	Min      string `json:"min"`
	Max      string `json:"max"`
	Units    string `json:"units"`
	Header   string `json:"header"`
}

type VehiclePIDConfig struct {
	ModelName string `json:"model_name"`
	PIDs      []PID  `json:"pids"`
}

func LoadPIDConfigs(path string) ([]VehiclePIDConfig, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var configs []VehiclePIDConfig
	var currentConfig *VehiclePIDConfig

	scanner := bufio.NewScanner(file)
	
	// Read line by line
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		// Check for Section Header
		if strings.HasPrefix(line, "===") {
			// Save previous config if exists
			if currentConfig != nil {
				configs = append(configs, *currentConfig)
			}
			
			// Start new config
			modelName := strings.Trim(line, "= ")
			currentConfig = &VehiclePIDConfig{
				ModelName: modelName,
				PIDs:      []PID{},
			}
			continue
		}

		// Parse PID line
		parts := strings.Split(line, ";")
		if len(parts) < 7 {
			// Skip malformed or header lines that don't match
			continue
		}

		// Skip the file header line itself if it appears
		if parts[0] == "Name" && parts[1] == "Mode/PID" {
			continue
		}

		pid := PID{
			Name:     parts[0],
			ModePID:  parts[1],
			Equation: parts[2],
			Min:      parts[3],
			Max:      parts[4],
			Units:    parts[5],
			Header:   parts[6],
		}

		if currentConfig != nil {
			currentConfig.PIDs = append(currentConfig.PIDs, pid)
		}
	}

	// Append the last one
	if currentConfig != nil {
		configs = append(configs, *currentConfig)
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return configs, nil
}
