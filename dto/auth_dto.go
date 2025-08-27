package dto

type RegisterRequest struct {
	Username string   `json:"username" binding:"required" example:"logan"`
	Email    string   `json:"email" binding:"required,email" example:"logan@example.com"`
	Password string   `json:"password" binding:"required" example:"123456"`
	Roles    []string `json:"roles" example:"[\"user\"]"`
}

type RegisterResponse struct {
	Message string `json:"message" example:"user created"`
}

type LoginRequest struct {
	Username string `json:"username" binding:"required" example:"logan"`
	Password string `json:"password" binding:"required" example:"123456"`
}

type LoginResponse struct {
	AccessToken      string `json:"access_token" example:"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."`
	ExpiresIn        int64  `json:"expires_in" example:"300"`
	NotBeforePolicy  int64  `json:"not-before-policy" example:"0"`
	RefreshExpiresIn int64  `json:"refresh_expires_in" example:"1800"`
	RefreshToken     string `json:"refresh_token" example:"eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9..."`
	Scope            string `json:"scope" example:"profile email"`
	SessionState     string `json:"session_state" example:"4d81e047-491f-47b2-8ce7-59e6c9e2fb9c"`
	TokenType        string `json:"token_type" example:"Bearer"`
}
