package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Vehicle struct {
	ID       string `json:"id"`
	Type     string `json:"type"` // "EV" or "ICE"
	Model    string `json:"model"`
	OwnerID  string `json:"owner_id"`
}

var vehicleConfigs []VehiclePIDConfig

func main() {
	var err error
	vehicleConfigs, err = LoadPIDConfigs("../ev_unified_professional.csv")
	if err != nil {
		log.Printf("Warning: Could not load PID configs: %v", err)
	} else {
		log.Printf("Loaded %d vehicle configurations", len(vehicleConfigs))
	}

	http.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]string{"status": "ok", "service": "mobility-backend"})
	})

	http.HandleFunc("/api/vehicle/register", registerVehicleHandler)
	http.HandleFunc("/api/vehicle/configs", getVehicleConfigsHandler)

	fmt.Println("Backend server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func registerVehicleHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}
	
	var v Vehicle
	if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	// In a real app, save to database
	log.Printf("Registered new vehicle: %+v", v)

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"status": "registered", "id": v.ID})
}

func getVehicleConfigsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(vehicleConfigs)
}
