package redis

import (
	"context"
	"time"

	"github.com/redis/go-redis/v9"
)

type Client struct {
	rdb *redis.Client
}

func NewClient(addr string, db int) *Client {
	rdb := redis.NewClient(&redis.Options{
		Addr: addr,
		DB:   db,
	})

	return &Client{rdb: rdb}
}

func (c *Client) Set(ctx context.Context, key string, value string, ttl time.Duration) error {
	return c.rdb.Set(ctx, key, value, ttl).Err()
}

func (c *Client) Get(ctx context.Context, key string) (string, error) {
	return c.rdb.Get(ctx, key).Result()
}

func (c *Client) Close() error {
	return c.rdb.Close()
}
