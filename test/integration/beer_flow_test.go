package integration_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/GoLogann/karhub-beer/adapter/http/handler"
	"github.com/GoLogann/karhub-beer/adapter/repository"
	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/dto"
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type mockSpotify struct{}

func (m *mockSpotify) GetPlaylistWithTracks(ctx context.Context, style, region string) (*spotify.PlaylistInfo, error) {
	return &spotify.PlaylistInfo{
		ID:    "123",
		Name:  style + " Playlist",
		Link:  "http://spotify.test/" + style,
		Tracks: []spotify.TrackInfo{
			{Name: "Song1", Artist: "Artist1", Link: "http://spotify.test/song1"},
		},
	}, nil
}

type mockCache struct {
	store map[string]string
}

func (m *mockCache) Get(ctx context.Context, key string) (string, error) {
	val, ok := m.store[key]
	if !ok {
		return "", gorm.ErrRecordNotFound
	}
	return val, nil
}
func (m *mockCache) Set(ctx context.Context, key, value string, ttl time.Duration) error {
	m.store[key] = value
	return nil
}


func setupTestDB(t *testing.T) *gorm.DB {
	t.Setenv("TEST_ENV", "true")
	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open sqlite: %v", err)
	}
	if err := db.AutoMigrate(&domain.BeerStyle{}); err != nil {
		t.Fatalf("failed to migrate schema: %v", err)
	}
	return db
}

func setupRouter(h *handler.BeerHandler) *gin.Engine {
	r := gin.Default()
	r.POST("/beers", h.Create)
	r.GET("/beers", h.GetAll)
	r.GET("/beers/:id", h.GetByID)
	r.PUT("/beers/:id", h.Update)
	r.DELETE("/beers/:id", h.Delete)
	r.POST("/beers/recommend", h.Recommend)
	return r
}

func TestBeerFlow_EndToEnd(t *testing.T) {
	db := setupTestDB(t)
	repo := repository.NewBeerRepository(db)
	uc := usecase.NewBeerUseCase(repo)
	spotify := &mockSpotify{}
	cache := &mockCache{store: make(map[string]string)}
	h := handler.NewBeerHandler(uc, spotify, cache)
	r := setupRouter(h)

	createReq := dto.BeerStyleRequest{Name: "IPA", MinTemperature: -7, MaxTemperature: 10}
	body, _ := json.Marshal(createReq)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/beers", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusCreated, w.Code)

	var created domain.BeerStyle
	_ = json.Unmarshal(w.Body.Bytes(), &created)
	assert.NotEqual(t, uuid.Nil, created.ID)

	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodGet, "/beers", nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "IPA")

	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodGet, "/beers/"+created.ID.String(), nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)

	updateReq := dto.BeerStyleRequest{Name: "IPA Atualizada", MinTemperature: -6, MaxTemperature: 12}
	body, _ = json.Marshal(updateReq)
	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodPut, "/beers/"+created.ID.String(), bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "IPA Atualizada")

	recReq := dto.TemperatureRequest{Temperature: -5}
	body, _ = json.Marshal(recReq)
	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodPost, "/beers/recommend", bytes.NewBuffer(body))
	req.Header.Set("Content-Type", "application/json")
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "IPA Playlist")

	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodDelete, "/beers/"+created.ID.String(), nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)

	w = httptest.NewRecorder()
	req, _ = http.NewRequest(http.MethodGet, "/beers/"+created.ID.String(), nil)
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusNotFound, w.Code)
}
