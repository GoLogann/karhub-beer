// @title KarHub Beer API
// @version 1.0
// @description API para gerenciar estilos de cerveja e encontrar o estilo ideal por temperatura
// @description
// @description Esta API faz parte do desafio de criar uma cervejeira inteligente.
// @description Ela permite gerenciar estilos de cerveja (CRUD) e recomendar o melhor estilo
// @description baseado na temperatura, incluindo uma playlist do Spotify relacionada ao estilo.
// @description
// @description ## Autenticação
// @description Esta API utiliza JWT Bearer tokens para autenticação.
// @description Algumas operações requerem role de admin.
// @description
// @description ## Regras de Negócio
// @description - Todo estilo de cerveja tem uma temperatura mínima e máxima
// @description - O cálculo para seleção do estilo é baseado na média das temperaturas
// @description - Em caso de empate, a ordenação é alfabética
// @description - A API integra com Spotify para buscar playlists relacionadas ao estilo
//
// @license.name MIT
// @license.url https://opensource.org/licenses/MIT
//
// @host localhost:8000
// @BasePath /
//
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @description Digite 'Bearer ' seguido do seu JWT token
//
// @tag.name Authentication
// @tag.description Endpoints de autenticação de usuários (registro e login)
//
// @tag.name Beer Styles
// @tag.description Gerenciamento dos estilos de cerveja (CRUD)
//
// @tag.name Beer Recommendation
// @tag.description Recomendação de estilos de cerveja por temperatura
package main

import (
	"github.com/GoLogann/karhub-beer/adapter/http"
	"github.com/GoLogann/karhub-beer/infra/postgres"
	"github.com/GoLogann/karhub-beer/module/auth"
	"github.com/GoLogann/karhub-beer/module/beer"
	"github.com/GoLogann/karhub-beer/module/redis"
	"github.com/GoLogann/karhub-beer/module/spotify"
	"github.com/GoLogann/karhub-beer/module/trace"

	_ "github.com/GoLogann/karhub-beer/docs"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"go.uber.org/fx"
)

func setupSwagger(r *gin.Engine) {
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
}

func main() {
	app := fx.New(
		trace.TracerModule(),    
		fx.Provide(postgres.InitDB),
		http.RouterModule(),
		spotify.SpotifyModule,
		redis.RedisModule,
		beer.BeerModule,
		auth.AuthModule,
		fx.Invoke(http.RegisterRoutes),
		fx.Invoke(func(r *gin.Engine) { setupSwagger(r) }),
	)

	app.Run()
}