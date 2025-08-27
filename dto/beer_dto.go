package dto

type BeerStyleRequest struct {
	Name           string  `json:"name" binding:"required" example:"IPA"`
	MinTemperature float64 `json:"min_temperature" binding:"required" example:"7.0"`
	MaxTemperature float64 `json:"max_temperature" binding:"required" example:"10.0"`
}

type BeerStyleResponse struct {
	ID             string  `json:"id" example:"123e4567-e89b-12d3-a456-426614174000"`
	Name           string  `json:"name" example:"IPA"`
	MinTemperature float64 `json:"min_temperature" example:"7.0"`
	MaxTemperature float64 `json:"max_temperature" example:"10.0"`
	CreatedAt      string  `json:"created_at" example:"2024-01-15T10:30:00Z"`
	UpdatedAt      string  `json:"updated_at" example:"2024-01-15T10:30:00Z"`
}

type TemperatureRequest struct {
	Temperature float64 `json:"temperature" binding:"required" example:"-7.0"`
}
