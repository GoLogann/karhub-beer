package auth


type Config struct {
	IssuerURL string
	ClientID  string
}

func NewAuthConfig() Config {
	issuer := "http://localhost:8080/realms/karhub-beer"

	client := "karhub-beer-api"

	return Config{
		IssuerURL: issuer,
		ClientID:  client,
	}
}
