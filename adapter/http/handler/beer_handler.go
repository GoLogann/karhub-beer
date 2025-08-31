package handler

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/dto"
	"github.com/GoLogann/karhub-beer/infra/redis"
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type BeerHandler struct {
	uc      usecase.BeerUsecaseInterface
	spotify spotify.SpotifyInterface
	cache   redis.RedisInterface
}

func NewBeerHandler(uc usecase.BeerUsecaseInterface, sc spotify.SpotifyInterface, cache redis.RedisInterface) *BeerHandler {
	return &BeerHandler{uc: uc, spotify: sc, cache: cache}
}

// Create godoc
// @Summary Criar novo estilo de cerveja
// @Description Cria um novo estilo de cerveja no sistema (requer autenticação de admin)
// @Tags Beer Styles
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param beer body dto.BeerStyleRequest true "Dados do estilo de cerveja"
// @Success 201 {object} dto.BeerStyleResponse "Estilo de cerveja criado com sucesso"
// @Failure 400 {object} dto.ErrorResponse "Dados inválidos"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 403 {object} dto.ErrorResponse "Acesso negado - requer role admin"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/beers [post]
func (h *BeerHandler) Create(c *gin.Context) {
	var req dto.BeerStyleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error()})
		return
	}

	style := domain.BeerStyle{
		ID:             uuid.New(),
		Name:           req.Name,
		MinTemperature: req.MinTemperature,
		MaxTemperature: req.MaxTemperature,
	}

	created, err := h.uc.Create(&style)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error()})
		return
	}

	c.JSON(http.StatusCreated, created)
}

// GetAll godoc
// @Summary Listar todos os estilos de cerveja
// @Description Retorna uma lista com todos os estilos de cerveja cadastrados
// @Tags Beer Styles
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {array} dto.BeerStyleResponse "Lista de estilos de cerveja"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/beers [get]
func (h *BeerHandler) GetAll(c *gin.Context) {
	styles, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, styles)
}

// GetByID godoc
// @Summary Buscar estilo de cerveja por ID
// @Description Retorna um estilo de cerveja específico pelo seu UUID
// @Tags Beer Styles
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "UUID do estilo de cerveja" format(uuid)
// @Success 200 {object} dto.BeerStyleResponse "Estilo de cerveja encontrado"
// @Failure 400 {object} dto.ErrorResponse "UUID inválido"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 404 {object} dto.ErrorResponse "Estilo de cerveja não encontrado"
// @Router /api/v1/beers/{id} [get]
func (h *BeerHandler) GetByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "Invalid beer style ID"})
		return
	}

	style, err := h.uc.GetByID(id)
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{Error: "beer style not found"})
		return
	}
	c.JSON(http.StatusOK, style)
}

// Update godoc
// @Summary Atualizar estilo de cerveja
// @Description Atualiza um estilo de cerveja existente (requer autenticação de admin)
// @Tags Beer Styles
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "UUID do estilo de cerveja" format(uuid)
// @Param beer body dto.BeerStyleRequest true "Dados atualizados do estilo de cerveja"
// @Success 200 {object} dto.BeerStyleResponse "Estilo de cerveja atualizado com sucesso"
// @Failure 400 {object} dto.ErrorResponse "Dados inválidos"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 403 {object} dto.ErrorResponse "Acesso negado - requer role admin"
// @Failure 404 {object} dto.ErrorResponse "Estilo de cerveja não encontrado"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/beers/{id} [put]
func (h *BeerHandler) Update(c *gin.Context) {
	var req dto.BeerStyleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error()})
		return
	}

	style := domain.BeerStyle{
		Name:           req.Name,
		MinTemperature: req.MinTemperature,
		MaxTemperature: req.MaxTemperature,
	}

	updated, err := h.uc.Update(&style)
	if err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error()})
		return
	}

	c.JSON(http.StatusOK, updated)
}

// Delete godoc
// @Summary Deletar estilo de cerveja
// @Description Remove um estilo de cerveja do sistema (requer autenticação de admin)
// @Tags Beer Styles
// @Security BearerAuth
// @Param id path string true "UUID do estilo de cerveja" format(uuid)
// @Success 200 {object} dto.SuccessMessage "Estilo de cerveja deletado com sucesso"
// @Failure 400 {object} dto.ErrorResponse "UUID inválido"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 403 {object} dto.ErrorResponse "Acesso negado - requer role admin"
// @Failure 404 {object} dto.ErrorResponse "Estilo de cerveja não encontrado"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/beers/{id} [delete]
func (h *BeerHandler) Delete(c *gin.Context) {
	idStr := c.Param("id")
	id, err := uuid.Parse(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: "Invalid beer style ID"})
		return
	}
	if err := h.uc.Delete(id); err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusOK, dto.SuccessMessage{Message: "beer style deleted"})
}

// Recommend godoc
// @Summary Recomendação de cerveja por temperatura
// @Description Retorna o estilo de cerveja mais adequado para a temperatura informada junto com uma playlist do Spotify
// @Tags Beer Recommendation
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param temperature body dto.TemperatureRequest true "Temperatura para recomendação"
// @Success 200 {object} dto.RecommendationResponse "Recomendação de cerveja e playlist"
// @Failure 400 {object} dto.ErrorResponse "Temperatura inválida"
// @Failure 401 {object} dto.ErrorResponse "Não autorizado"
// @Failure 404 {object} dto.ErrorResponse "Nenhum estilo de cerveja encontrado ou playlist não disponível"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/beers/recommend [post]
func (h *BeerHandler) Recommend(c *gin.Context) {
	var req dto.TemperatureRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error()})
		return
	}

	cacheKey := fmt.Sprintf("recommend:%v", req.Temperature)
	ctx := c.Request.Context()

	if cached, err := h.cache.Get(ctx, cacheKey); err == nil {
		c.Data(http.StatusOK, "application/json", []byte(cached))
		return
	}

	style, err := h.uc.FindClosest(req.Temperature)
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{Error: "no beer style found"})
		return
	}

	ctx, cancel := context.WithTimeout(ctx, 15*time.Second)
	defer cancel()

	playlist, err := h.spotify.GetPlaylistWithTracks(ctx, style.Name, "BR")
	if err != nil {
		c.JSON(http.StatusNotFound, dto.ErrorResponse{Error: "no playlist found for style"})
		return
	}

	resp := dto.RecommendationResponse{
		BeerStyle: style.Name,
		Playlist:  *playlist,
	}

	jsonResp, _ := json.Marshal(resp)
	_ = h.cache.Set(ctx, cacheKey, string(jsonResp), time.Hour)

	c.JSON(http.StatusOK, resp)
}