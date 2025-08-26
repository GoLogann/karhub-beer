package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type BeerHandler struct {
	uc      *usecase.BeerUseCase
	spotify *spotify.Client
}

func NewBeerHandler(uc *usecase.BeerUseCase, sc *spotify.Client) *BeerHandler {
	return &BeerHandler{uc: uc, spotify: sc}
}

func (h *BeerHandler) Create(c *gin.Context) {
	var style domain.BeerStyle
	if err := c.ShouldBindJSON(&style); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	style.ID = uuid.New()
	created, err := h.uc.Create(&style)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, created)
}

func (h *BeerHandler) GetAll(c *gin.Context) {
	styles, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, styles)
}

func (h *BeerHandler) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid beer style ID"})
		return
	}

	style, err := h.uc.GetByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "beer style not found"})
		return
	}
	c.JSON(http.StatusOK, style)
}

func (h *BeerHandler) Update(c *gin.Context) {
	var style domain.BeerStyle
	if err := c.ShouldBindJSON(&style); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	updated, err := h.uc.Update(&style)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, updated)
}

func (h *BeerHandler) Delete(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid beer style ID"})
		return
	}
	if err := h.uc.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "beer style deleted"})
}

func (h *BeerHandler) Recommend(c *gin.Context) {
	var payload struct {
		Temperature float64 `json:"temperature"`
	}
	if err := c.ShouldBindJSON(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	style, err := h.uc.FindClosest(payload.Temperature)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "no beer style found"})
		return
	}

	ctx, cancel := context.WithTimeout(c.Request.Context(), 15*time.Second)
	defer cancel()

	playlist, err := h.spotify.GetPlaylistWithTracks(ctx, style.Name, "BR")
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "no playlist found for style"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"beerStyle": style.Name,
		"playlist": gin.H{
			"name":   playlist.Name,
			"tracks": playlist.Tracks,
		},
	})
}