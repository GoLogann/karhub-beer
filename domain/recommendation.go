package domain

import (
	"time"

	"github.com/google/uuid"
)

type Recommendation struct {
	ID               uuid.UUID `gorm:"type:uuid;primaryKey"`
	BeerStyleID      uint      `gorm:"not null"`
	BeerStyle        BeerStyle `gorm:"foreignKey:BeerStyleID"`
	InputTemperature float64   `gorm:"not null"`
	CreatedAt        time.Time
}