package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/superapp/backend/pkg/evdata"
)

func main() {
	http.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Write([]byte(`{"status":"ok", "message":"Super App Backend is running"}`))
	})

	http.HandleFunc("/api/ev-specs", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		// Assuming running from the root of the backend directory
		data, err := evdata.LoadEVData("data/ev_unified_professional.csv")
		if err != nil {
			http.Error(w, fmt.Sprintf("Error loading EV data: %v", err), http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(data)
	})

	fmt.Println("Server starting on :8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
