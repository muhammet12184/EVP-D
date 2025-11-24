package evdata

import (
	"bufio"
	"os"
	"strings"
)

type EVParam struct {
	Name     string `json:"name"`
	ModePID  string `json:"mode_pid"`
	Equation string `json:"equation"`
	Min      string `json:"min"`
	Max      string `json:"max"`
	Units    string `json:"units"`
	Header   string `json:"header"`
}

type EVModel struct {
	Name   string    `json:"name"`
	Params []EVParam `json:"params"`
}

func LoadEVData(path string) ([]EVModel, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var models []EVModel
	var currentModel *EVModel

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Split(line, ";")
		
		if len(parts) < 1 {
			continue
		}

		// Check for model header
		if strings.HasPrefix(parts[0], "===") {
			modelName := strings.Trim(parts[0], "= ")
			if currentModel != nil {
				models = append(models, *currentModel)
			}
			currentModel = &EVModel{
				Name:   modelName,
				Params: []EVParam{},
			}
			continue
		}

		// Skip file header or empty lines
		if parts[0] == "Name" || len(parts) < 7 {
			continue
		}

		if currentModel != nil {
			param := EVParam{
				Name:     parts[0],
				ModePID:  parts[1],
				Equation: parts[2],
				Min:      parts[3],
				Max:      parts[4],
				Units:    parts[5],
				Header:   parts[6],
			}
			currentModel.Params = append(currentModel.Params, param)
		}
	}

	if currentModel != nil {
		models = append(models, *currentModel)
	}

	return models, scanner.Err()
}
