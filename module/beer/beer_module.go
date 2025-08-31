package beer

import (
	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/GoLogann/karhub-beer/adapter/repository"
	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"github.com/GoLogann/karhub-beer/infra/redis"
	"go.uber.org/fx"
	"gorm.io/gorm"
)

var BeerModule = fx.Options(
    fx.Provide(NewBeerRepository),
    fx.Provide(NewBeerUseCase),
    fx.Provide(NewBeerHandler),
)

func NewBeerRepository(db *gorm.DB) repository.BeerRepository {
    return repository.NewBeerRepository(db)
}

func NewBeerUseCase(repo repository.BeerRepository) usecase.BeerUsecaseInterface {
    return usecase.NewBeerUseCase(repo)
}

func NewBeerHandler(
    uc usecase.BeerUsecaseInterface,
    sc spotify.SpotifyInterface,
    cache redis.RedisInterface,
) *handler.BeerHandler {
    return handler.NewBeerHandler(uc, sc, cache)
}
