package usecase

import (
	"encoding/json"

	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/dto"
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

func (uc *AuthUsecase) Login(username, password string) (*dto.LoginResponse, error) {
	res, err := uc.kc.Login(username, password)
	if err != nil {
		return nil, err
	}

	bytes, _ := json.Marshal(res)
	var token dto.LoginResponse
	if err := json.Unmarshal(bytes, &token); err != nil {
		return nil, err
	}

	return &token, nil
}