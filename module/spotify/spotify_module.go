package spotify

import (
	"github.com/GoLogann/karhub-beer/infra/spotify"
	"go.uber.org/fx"
)

var SpotifyModule = fx.Options(
	fx.Provide(NewSpotifyClient),
)

func NewSpotifyClient() spotify.SpotifyInterface {
	return spotify.NewClient()
}
