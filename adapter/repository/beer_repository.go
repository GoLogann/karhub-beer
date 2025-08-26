package repository

import (
	"github.com/GoLogann/karhub-beer/domain"
	"gorm.io/gorm"
)

type BeerRepository interface {
	Repository[domain.BeerStyle]
}

type beerRepository struct {
	Repository[domain.BeerStyle]
	db *gorm.DB
}

func NewBeerRepository(db *gorm.DB) BeerRepository {
	return &beerRepository{
		Repository: NewRepository[domain.BeerStyle](db),
		db:         db,
	}
}