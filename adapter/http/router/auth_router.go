package router

import (
	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/gin-gonic/gin"
)

func SetupAuthRoutes(r *gin.Engine, h *handler.AuthHandler) {
	group := r.Group("/api/v1/auth")
	{
		group.POST("/register", h.Register)
		group.POST("/login", h.Login)
	}
}
