package redis

import (
	"os"

	"github.com/GoLogann/karhub-beer/infra/redis"
	"go.uber.org/fx"
)

var RedisModule = fx.Options(
	fx.Provide(NewRedisClient),
)

func NewRedisClient() *redis.Client {
	addr := os.Getenv("REDIS_HOST")
	db := 0

	return redis.NewClient(addr, db)
}
