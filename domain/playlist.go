package domain

import (
	"time"

	"github.com/google/uuid"
)

type Playlist struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey"`
	BeerStyleID uint      `gorm:"not null"`
	BeerStyle   BeerStyle `gorm:"foreignKey:BeerStyleID"`
	SpotifyID   string    `gorm:"size:100;not null"`
	Name        string    `gorm:"size:200;not null"`
	URL         string    `gorm:"not null"`
	CreatedAt   time.Time
}
