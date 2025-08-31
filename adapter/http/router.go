package http

import (
	"context"

	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/GoLogann/karhub-beer/adapter/http/router"
	"github.com/GoLogann/karhub-beer/infra/auth"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.uber.org/fx"
)

func StartServer(lc fx.Lifecycle, r *gin.Engine) {
	port := ":8082"
	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			go func() {
				logrus.Infof("API rodando na porta %s", port)
				if err := r.Run(port); err != nil {
					logrus.Errorf("Erro ao iniciar o servidor: %v", err)
				}
			}()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			logrus.Info("API foi finalizada")
			return nil
		},
	})
}

func RegisterRoutes(
	r *gin.Engine,
	beerHandler *handler.BeerHandler,
	authHandler *handler.AuthHandler,
	m *auth.Middleware,
) {
	router.SetupAuthRoutes(r, authHandler)

	protected := r.Group("/api/v1")
	protected.Use(m.JWTAuthMiddleware())

	router.SetupBeerRoutes(protected, beerHandler)
}

func SetupRouter() *gin.Engine {
	r := gin.New()

	r.Use(otelgin.Middleware("karhub-beer-api"))

	r.Use(gin.Logger())
	r.Use(gin.Recovery())

	return r
}

func RouterModule() fx.Option {
	return fx.Options(
		fx.Provide(SetupRouter),
		fx.Invoke(StartServer),
	)
}
