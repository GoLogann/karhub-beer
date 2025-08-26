package router

import (
	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/gin-gonic/gin"
)

func SetupBeerRoutes(r *gin.Engine, h *handler.BeerHandler) {
	group := r.Group("/api/v1/beers")
	{
		group.POST("/", h.Create)
		group.GET("/", h.GetAll)
		group.GET("/:id", h.GetByID)
		group.PUT("/:id", h.Update)
		group.DELETE("/:id", h.Delete)

		group.POST("/recommend", h.Recommend)
	}
}
