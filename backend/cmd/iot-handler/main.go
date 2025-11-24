package main

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"super-mobility-backend/pkg/iot"
	"super-mobility-backend/internal/config"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	cfg := config.Load()

	// Initialize IoT handler
	handler := iot.NewHandler(cfg.IoTEndpoint)

	// Connect to AWS IoT Core
	if err := handler.Connect(); err != nil {
		log.Fatalf("Failed to connect to AWS IoT: %v", err)
	}

	log.Println("IoT Handler connected successfully")

	// Subscribe to vehicle data topics
	topics := []string{
		"vehicles/+/battery",
		"vehicles/+/obd",
		"vehicles/+/location",
		"vehicles/+/charging",
	}

	for _, topic := range topics {
		if err := handler.Subscribe(topic); err != nil {
			log.Printf("Failed to subscribe to %s: %v", topic, err)
		}
	}

	// Keep running
	select {}
}
