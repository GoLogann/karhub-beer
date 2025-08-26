package redis

import (
	"github.com/GoLogann/karhub-beer/infra/redis"
	"go.uber.org/fx"
)

var RedisModule = fx.Options(
	fx.Provide(NewRedisClient),
)

func NewRedisClient() *redis.Client {
	addr := "localhost:6379"
	password := ""
	db := 0

	return redis.NewClient(addr, password, db)
}
