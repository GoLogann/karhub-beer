package dto

import "github.com/GoLogann/karhub-beer/infra/spotify"

type RecommendationResponse struct {
	BeerStyle string              `json:"beerStyle" example:"IPA"`
	Playlist  spotify.PlaylistInfo `json:"playlist"`
}
