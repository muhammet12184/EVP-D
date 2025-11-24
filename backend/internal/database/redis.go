package database

import (
	"context"
	"time"

	"github.com/redis/go-redis/v9"
)

type Redis struct {
	Client *redis.Client
}

func NewRedis(connectionString string) *Redis {
	opt, err := redis.ParseURL(connectionString)
	if err != nil {
		// Fallback to default
		opt = &redis.Options{
			Addr: "localhost:6379",
		}
	}

	client := redis.NewClient(opt)

	// Test connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := client.Ping(ctx).Err(); err != nil {
		// Log error but don't fail
		// In production, you might want to handle this differently
	}

	return &Redis{
		Client: client,
	}
}

func (r *Redis) Close() error {
	return r.Client.Close()
}
