package router

import (
	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/gin-gonic/gin"
	"github.com/GoLogann/karhub-beer/infra/auth"
)

func SetupBeerRoutes(r *gin.RouterGroup, h *handler.BeerHandler) {
	group := r.Group("/beers")
	{
		group.GET("/", h.GetAll)
		group.GET("/:id", h.GetByID)
		group.POST("/recommend", h.Recommend)

		group.POST("/", auth.RoleAuthMiddleware("admin"), h.Create)
		group.PUT("/:id", auth.RoleAuthMiddleware("admin"), h.Update)
		group.DELETE("/:id", auth.RoleAuthMiddleware("admin"), h.Delete)
	}
}
