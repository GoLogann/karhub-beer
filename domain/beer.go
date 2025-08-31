package domain

import (
	"errors"
	"os"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
)

type BeerStyle struct {
	ID             uuid.UUID `gorm:"primaryKey"`
	Name           string    `gorm:"uniqueIndex;size:100;not null" validate:"required"`
	MinTemperature float64   `gorm:"not null" validate:"required"`
	MaxTemperature float64   `gorm:"not null" validate:"required"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

func (bs *BeerStyle) TableName() string {
	if os.Getenv("TEST_ENV") == "true" {
        return "beer_styles"
    }
	return "karhub_beer.beer_styles"
}

func (bs *BeerStyle) Validate() error {
	validate := validator.New()
	if err := validate.Struct(bs); err != nil {
		return err
	}
	if bs.MinTemperature >= bs.MaxTemperature {
		return errors.New("min_temperature must be less than max_temperature")
	}
	return nil
}

func (bs *BeerStyle) AvgTemperature() float64 {
	return (bs.MinTemperature + bs.MaxTemperature) / 2.0
}
