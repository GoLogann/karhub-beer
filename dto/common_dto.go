package dto

type ErrorResponse struct {
	Error string `json:"error" example:"Beer style not found"`
}

type SuccessMessage struct {
	Message string `json:"message" example:"beer style deleted"`
}
