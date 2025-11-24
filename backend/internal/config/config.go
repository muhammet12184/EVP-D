package config

import (
	"os"
)

type Config struct {
	Environment      string
	DatabaseURL      string
	RedisURL         string
	AWSRegion        string
	AWSEndpoint      string
	IoTEndpoint      string
	JWTSecret        string
	MapboxToken      string
	StripeSecretKey  string
	BlockchainRPCURL string
}

func Load() *Config {
	return &Config{
		Environment:      getEnv("ENVIRONMENT", "development"),
		DatabaseURL:      getEnv("DATABASE_URL", "mongodb://localhost:27017"),
		RedisURL:         getEnv("REDIS_URL", "redis://localhost:6379"),
		AWSRegion:        getEnv("AWS_REGION", "us-east-1"),
		AWSEndpoint:      getEnv("AWS_ENDPOINT", ""),
		IoTEndpoint:      getEnv("AWS_IOT_ENDPOINT", ""),
		JWTSecret:        getEnv("JWT_SECRET", "change-me-in-production"),
		MapboxToken:      getEnv("MAPBOX_TOKEN", ""),
		StripeSecretKey:  getEnv("STRIPE_SECRET_KEY", ""),
		BlockchainRPCURL: getEnv("BLOCKCHAIN_RPC_URL", ""),
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
