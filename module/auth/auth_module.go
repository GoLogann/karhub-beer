package auth

import (
	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/GoLogann/karhub-beer/core/usecase"
	infra "github.com/GoLogann/karhub-beer/infra/auth"
	"go.uber.org/fx"
)

var AuthModule = fx.Options(
	fx.Provide(
		infra.NewAuthConfig,     
		infra.NewAuthMiddleware, 
		infra.NewKeycloakClient, 
		usecase.NewAuthUsecase,
		handler.NewAuthHandler,
	),
)
