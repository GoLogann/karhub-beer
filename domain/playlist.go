package domain

import (
	"errors"
	"net/url"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
)

type Playlist struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey"`
	BeerStyleID uint      `gorm:"not null" validate:"required"`
	BeerStyle   BeerStyle `gorm:"foreignKey:BeerStyleID"`
	SpotifyID   string    `gorm:"size:100;not null" validate:"required"`
	Name        string    `gorm:"size:200;not null" validate:"required"`
	URL         string    `gorm:"not null" validate:"required,url"`
	CreatedAt   time.Time
}

func (p *Playlist) Validate() error {
	validate := validator.New()
	if err := validate.Struct(p); err != nil {
		return err
	}
	if _, err := url.ParseRequestURI(p.URL); err != nil {
		return errors.New("invalid URL format")
	}
	return nil
}
