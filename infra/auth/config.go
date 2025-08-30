package auth

import "os"


type Config struct {
	IssuerURL string
	ClientID  string
}

func NewAuthConfig() Config {
	issuer := os.Getenv("KC_ISSUER_URL")

	client := os.Getenv("KC_CLIENT_ID")

	return Config{
		IssuerURL: issuer,
		ClientID:  client,
	}
}
