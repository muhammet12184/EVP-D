package config

import (
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	DatabaseURL    string
	RedisURL       string
	AWSIoTEndpoint string
	AWSRegion      string
	JWTSecret      string
	MapboxToken    string
	AIServiceURL   string
}

func Load() *Config {
	// Load .env file if exists
	_ = godotenv.Load()

	return &Config{
		DatabaseURL:    getEnv("DATABASE_URL", "mongodb://localhost:27017/superapp"),
		RedisURL:       getEnv("REDIS_URL", "redis://localhost:6379"),
		AWSIoTEndpoint: getEnv("AWS_IOT_ENDPOINT", ""),
		AWSRegion:      getEnv("AWS_REGION", "eu-central-1"),
		JWTSecret:      getEnv("JWT_SECRET", "change-me-in-production"),
		MapboxToken:    getEnv("MAPBOX_TOKEN", ""),
		AIServiceURL:   getEnv("AI_SERVICE_URL", "http://localhost:8000"),
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
