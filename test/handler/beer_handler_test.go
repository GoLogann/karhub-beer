package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/dto"
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

type mockBeerUsecase struct {
	style  *domain.BeerStyle
	styles []*domain.BeerStyle
	err    error
}

func (m *mockBeerUsecase) Create(s *domain.BeerStyle) (*domain.BeerStyle, error) {
	return m.style, m.err
}
func (m *mockBeerUsecase) Update(s *domain.BeerStyle) (*domain.BeerStyle, error) {
	return m.style, m.err
}
func (m *mockBeerUsecase) Delete(id uuid.UUID) error                       { return m.err }
func (m *mockBeerUsecase) GetByID(id uuid.UUID) (*domain.BeerStyle, error) { return m.style, m.err }
func (m *mockBeerUsecase) GetAll() ([]*domain.BeerStyle, error) {
	if m.styles != nil {
		return m.styles, m.err
	}
	if m.style != nil {
		return []*domain.BeerStyle{m.style}, m.err
	}
	return []*domain.BeerStyle{}, m.err
}
func (m *mockBeerUsecase) FindClosest(temp float64) (*domain.BeerStyle, error) { return m.style, m.err }

type mockSpotify struct {
	playlist *spotify.PlaylistInfo
	err      error
}

func (m *mockSpotify) GetPlaylistWithTracks(ctx context.Context, style, region string) (*spotify.PlaylistInfo, error) {
	return m.playlist, m.err
}

type mockCache struct {
	store map[string]string
}

func (m *mockCache) Get(ctx context.Context, key string) (string, error) {
	if val, ok := m.store[key]; ok {
		return val, nil
	}
	return "", errors.New("cache miss")
}
func (m *mockCache) Set(ctx context.Context, key, value string, ttl time.Duration) error {
	m.store[key] = value
	return nil
}


func setupRouter(h *handler.BeerHandler) *gin.Engine {
	r := gin.Default()
	r.GET("/beers", h.GetAll)
	r.GET("/beers/:id", h.GetByID)
	r.POST("/beers", h.Create)
	r.PUT("/beers/:id", h.Update)
	r.DELETE("/beers/:id", h.Delete)
	r.POST("/beers/recommend", h.Recommend)
	return r
}

func TestBeerHandler_GetAll(t *testing.T) {
	mockStyle := &domain.BeerStyle{ID: uuid.New(), Name: "IPA"}
	uc := &mockBeerUsecase{style: mockStyle}
	h := handler.NewBeerHandler(uc, nil, nil)
	r := setupRouter(h)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/beers", nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "IPA")
}

func TestBeerHandler_Create(t *testing.T) {
	uc := &mockBeerUsecase{style: &domain.BeerStyle{Name: "Weissbier"}}
	h := handler.NewBeerHandler(uc, nil, nil)
	r := setupRouter(h)

	body := dto.BeerStyleRequest{Name: "Weissbier", MinTemperature: -1, MaxTemperature: 3}
	b, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers", bytes.NewBuffer(b))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
	assert.Contains(t, w.Body.String(), "Weissbier")
}

func TestBeerHandler_GetByID_InvalidUUID(t *testing.T) {
	h := handler.NewBeerHandler(&mockBeerUsecase{}, nil, nil)
	r := setupRouter(h)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/beers/invalid-uuid", nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestBeerHandler_GetByID_NotFound(t *testing.T) {
	uc := &mockBeerUsecase{style: nil, err: errors.New("not found")}
	h := handler.NewBeerHandler(uc, nil, nil)
	r := setupRouter(h)

	id := uuid.New()
	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/beers/"+id.String(), nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestBeerHandler_Update(t *testing.T) {
	uc := &mockBeerUsecase{style: &domain.BeerStyle{Name: "Updated"}}
	h := handler.NewBeerHandler(uc, nil, nil)
	r := setupRouter(h)

	body := dto.BeerStyleRequest{
		Name:           "heineken",
		MinTemperature: -1,
		MaxTemperature: 5,
	}
	b, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPut, "/beers/"+uuid.New().String(), bytes.NewBuffer(b))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Updated")
}

func TestBeerHandler_Update_InvalidBody(t *testing.T) {
	h := handler.NewBeerHandler(&mockBeerUsecase{}, nil, nil)
	r := setupRouter(h)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPut, "/beers/"+uuid.New().String(), bytes.NewBuffer([]byte(`invalid-json`)))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestBeerHandler_Delete(t *testing.T) {
	uc := &mockBeerUsecase{}
	h := handler.NewBeerHandler(uc, nil, nil)
	r := setupRouter(h)

	id := uuid.New()
	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodDelete, "/beers/"+id.String(), nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "beer style deleted")
}

func TestBeerHandler_Delete_InvalidUUID(t *testing.T) {
	h := handler.NewBeerHandler(&mockBeerUsecase{}, nil, nil)
	r := setupRouter(h)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodDelete, "/beers/invalid-uuid", nil)
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestBeerHandler_Recommend_Success(t *testing.T) {
	mockStyle := &domain.BeerStyle{Name: "IPA"}
	uc := &mockBeerUsecase{style: mockStyle}
	spotify := &mockSpotify{playlist: &spotify.PlaylistInfo{Name: "IPA Playlist"}}
	cache := &mockCache{store: make(map[string]string)}

	h := handler.NewBeerHandler(uc, spotify, cache)
	r := setupRouter(h)

	body := dto.TemperatureRequest{Temperature: -5}
	b, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers/recommend", bytes.NewBuffer(b))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "IPA Playlist")
}

func TestBeerHandler_Recommend_NoStyles(t *testing.T) {
	uc := &mockBeerUsecase{style: nil, err: errors.New("no beer style found")}
	h := handler.NewBeerHandler(uc, &mockSpotify{}, &mockCache{store: map[string]string{}})
	r := setupRouter(h)

	body := dto.TemperatureRequest{Temperature: -5}
	b, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers/recommend", bytes.NewBuffer(b))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestBeerHandler_Recommend_NoPlaylist(t *testing.T) {
	mockStyle := &domain.BeerStyle{Name: "IPA"}
	uc := &mockBeerUsecase{style: mockStyle}
	spotify := &mockSpotify{playlist: nil, err: errors.New("no playlist")}
	cache := &mockCache{store: make(map[string]string)}

	h := handler.NewBeerHandler(uc, spotify, cache)
	r := setupRouter(h)

	body := dto.TemperatureRequest{Temperature: -5}
	b, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers/recommend", bytes.NewBuffer(b))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestBeerHandler_Recommend_InvalidBody(t *testing.T) {
	h := handler.NewBeerHandler(&mockBeerUsecase{}, &mockSpotify{}, &mockCache{store: make(map[string]string)})
	r := setupRouter(h)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers/recommend", bytes.NewBuffer([]byte(`invalid-json`)))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}
