package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"super-app/backend/internal/api"
	"super-app/backend/internal/config"
	"super-app/backend/internal/database"
	"super-app/backend/internal/iot"
)

func main() {
	// Load configuration
	cfg := config.Load()

	// Initialize database
	db, err := database.NewMongoDB(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Initialize Redis for caching
	redisClient := database.NewRedis(cfg.RedisURL)
	defer redisClient.Close()

	// Initialize AWS IoT Core
	iotClient, err := iot.NewAWSIoTClient(cfg.AWSIoTEndpoint, cfg.AWSRegion)
	if err != nil {
		log.Fatalf("Failed to initialize IoT client: %v", err)
	}

	// Setup router
	router := gin.Default()

	// Setup API routes
	api.SetupRoutes(router, db, redisClient, iotClient, cfg)

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
