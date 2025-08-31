package repository_test

import (
	"os"
	"testing"
	"time"

	"github.com/GoLogann/karhub-beer/adapter/repository"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)
// Unitários de domínio → cálculos e seleção de estilos.

// Unitários de repositório → CRUD no banco (usar SQLite em memória).

// Unitários de handler → HTTP endpoints.

// Mocks do Spotify → garantir comportamento mesmo sem internet.

// Integração → fluxo fim a fim.
func setupTestDB(t *testing.T) *gorm.DB {
	os.Setenv("TEST_ENV", "true")

	db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	if err != nil {
		t.Fatalf("falha ao abrir banco em memória: %v", err)
	}

	err = db.AutoMigrate(&domain.BeerStyle{})
	if err != nil {
		t.Fatalf("falha ao migrar schema: %v", err)
	}

	return db
}

func TestBeerRepository_CRUD(t *testing.T) {
	db := setupTestDB(t)
	repo := repository.NewBeerRepository(db)

	// Criar
	style := &domain.BeerStyle{
		ID:             uuid.New(),
		Name:           "IPA",
		MinTemperature: -7,
		MaxTemperature: 10,
		CreatedAt:      time.Now(),
		UpdatedAt:      time.Now(),
	}
	created, err := repo.Create(style)
	assert.NoError(t, err)
	assert.NotNil(t, created)
	assert.Equal(t, "IPA", created.Name)

	// Buscar por ID
	fetched, err := repo.GetByID(style.ID)
	assert.NoError(t, err)
	assert.Equal(t, style.Name, fetched.Name)

	// Atualizar
	style.Name = "IPA Atualizada"
	updated, err := repo.Update(style)
	assert.NoError(t, err)
	assert.Equal(t, "IPA Atualizada", updated.Name)

	// Listar todos
	all, err := repo.GetAll()
	assert.NoError(t, err)
	assert.Len(t, all, 1)
	assert.Equal(t, "IPA Atualizada", all[0].Name)

	// Deletar
	err = repo.Delete(style.ID)
	assert.NoError(t, err)

	// Garantir que foi deletado
	_, err = repo.GetByID(style.ID)
	assert.Error(t, err) // deve dar record not found
}
