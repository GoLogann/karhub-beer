package redis

import (
	"context"
	"time"

	"github.com/redis/go-redis/extra/redisotel/v9"
	"github.com/redis/go-redis/v9"
	"github.com/sirupsen/logrus"
)

type Client struct {
    rdb *redis.Client
}

func NewClient(addr string, db int) *Client {
    rdb := redis.NewClient(&redis.Options{
        Addr: addr,
        DB:   db,
    })

    if err := redisotel.InstrumentTracing(rdb); err != nil {
        logrus.Printf("failed to instrument tracing: %v", err)
    }

    if err := redisotel.InstrumentMetrics(rdb); err != nil {
        logrus.Printf("failed to instrument metrics: %v", err)
    }

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
