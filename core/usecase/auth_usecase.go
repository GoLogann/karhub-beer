package usecase

import (
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/infra/auth"
)

type AuthUsecase struct {
	kc *auth.KeycloakClient
}

func NewAuthUsecase(kc *auth.KeycloakClient) *AuthUsecase {
	return &AuthUsecase{kc: kc}
}

func (uc *AuthUsecase) Register(u domain.User) error {
	return uc.kc.CreateUser(u)
}

func (uc *AuthUsecase) Login(username, password string) (map[string]interface{}, error) {
	return uc.kc.Login(username, password)
}
