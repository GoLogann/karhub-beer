package domain

import (
	"errors"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
)

type Recommendation struct {
	ID               uuid.UUID `gorm:"type:uuid;primaryKey"`
	BeerStyleID      uint      `gorm:"not null" validate:"required"`
	BeerStyle        BeerStyle `gorm:"foreignKey:BeerStyleID"`
	InputTemperature float64   `gorm:"not null" validate:"required"`
	CreatedAt        time.Time
}

func (r *Recommendation) Validate() error {
	validate := validator.New()
	if err := validate.Struct(r); err != nil {
		return err
	}
	if r.BeerStyleID == 0 {
		return errors.New("beer_style_id is required")
	}
	return nil
}