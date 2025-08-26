package spotify

type TokenResponse struct {
	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	ExpiresIn   int    `json:"expires_in"`
}

type ErrorResponse struct {
	Error struct {
		Status  int    `json:"status"`
		Message string `json:"message"`
	} `json:"error"`
}

type SearchResponse struct {
	Playlists struct {
		Items []struct {
			ID           string `json:"id"`
			Name         string `json:"name"`
			ExternalUrls struct {
				Spotify string `json:"spotify"`
			} `json:"external_urls"`
			Images []struct {
				URL string `json:"url"`
			} `json:"images"`
		} `json:"items"`
		Total  int    `json:"total"`
		Limit  int    `json:"limit"`
		Offset int    `json:"offset"`
		Next   string `json:"next"`
		Prev   string `json:"previous"`
	} `json:"playlists"`
}

type TracksResponse struct {
	Items []struct {
		Track *struct { // pode vir null quando item é episode
			ID     string `json:"id"`
			Name   string `json:"name"`
			Type   string `json:"type"` // "track" ou "episode"
			Artists []struct {
				Name string `json:"name"`
			} `json:"artists"`
			ExternalUrls struct {
				Spotify string `json:"spotify"`
			} `json:"external_urls"`
		} `json:"track"`
	} `json:"items"`
	Next string `json:"next"`
}

type TrackInfo struct {
	ID     string `json:"id"`
	Name   string `json:"name"`
	Artist string `json:"artist"`
	Link   string `json:"link"`
}

type PlaylistInfo struct {
	ID     string      `json:"id"`
	Name   string      `json:"name"`
	Link   string      `json:"link"`
	Image  string      `json:"image,omitempty"`
	Tracks []TrackInfo `json:"tracks,omitempty"` // preenchido manualmente
}