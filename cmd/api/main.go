package main

import (
	"github.com/GoLogann/karhub-beer/adapter/http"
	"github.com/GoLogann/karhub-beer/infra/postgres"
	"github.com/GoLogann/karhub-beer/module/auth"
	"github.com/GoLogann/karhub-beer/module/beer"
	"github.com/GoLogann/karhub-beer/module/spotify"
	"github.com/GoLogann/karhub-beer/module/redis"
	"go.uber.org/fx"
)

func main() {
	app := fx.New(
		fx.Provide(postgres.InitDB),
		http.RouterModule(),
		spotify.SpotifyModule,
		redis.RedisModule,
		beer.BeerModule,
		auth.AuthModule,
		fx.Invoke(http.RegisterRoutes),
	)

	app.Run()
}