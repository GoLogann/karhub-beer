package domain

import (
	"time"

	"github.com/google/uuid"
)

type BeerStyle struct {
	ID             uuid.UUID `gorm:"primaryKey"`
	Name           string    `gorm:"uniqueIndex;size:100;not null"`
	MinTemperature float64   `gorm:"not null"`
	MaxTemperature float64   `gorm:"not null"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

func (bs *BeerStyle) TableName() string {
	return "karhub_beer.beer_styles"
}

func (bs *BeerStyle) AvgTemperature() float64 {
	return (bs.MinTemperature + bs.MaxTemperature) / 2.0
}
