package handler

import (
	"net/http"

	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/GoLogann/karhub-beer/dto"
	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	uc *usecase.AuthUsecase
}

func NewAuthHandler(uc *usecase.AuthUsecase) *AuthHandler {
	return &AuthHandler{uc: uc}
}

// Register godoc
// @Summary Registrar novo usuário
// @Description Cria um novo usuário no sistema
// @Tags Authentication
// @Accept json
// @Produce json
// @Param user body dto.RegisterRequest true "Dados do usuário"
// @Success 201 {object} dto.RegisterResponse "Usuário criado com sucesso"
// @Failure 400 {object} dto.ErrorResponse "Dados inválidos"
// @Failure 500 {object} dto.ErrorResponse "Erro interno do servidor"
// @Router /api/v1/auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req dto.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error()})
		return
	}

	user := domain.User{
		Username: req.Username,
		Email:    req.Email,
		Password: req.Password,
		Roles:    req.Roles,
	}

	if err := h.uc.Register(user); err != nil {
		c.JSON(http.StatusInternalServerError, dto.ErrorResponse{Error: err.Error()})
		return
	}
	c.JSON(http.StatusCreated, dto.RegisterResponse{Message: "user created"})
}

// Login godoc
// @Summary Login de usuário
// @Description Autentica usuário e retorna token JWT (Keycloak)
// @Tags Authentication
// @Accept json
// @Produce json
// @Param credentials body dto.LoginRequest true "Credenciais de login"
// @Success 200 {object} dto.LoginResponse "Login realizado com sucesso"
// @Failure 400 {object} dto.ErrorResponse "Dados inválidos"
// @Failure 401 {object} dto.ErrorResponse "Credenciais inválidas"
// @Router /api/v1/auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var creds dto.LoginRequest
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, dto.ErrorResponse{Error: err.Error()})
		return
	}

	token, err := h.uc.Login(creds.Username, creds.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, dto.ErrorResponse{Error: err.Error()})
		return
	}

	c.JSON(http.StatusOK, token)
}