package usecase_test

import (
	"testing"

	"github.com/GoLogann/karhub-beer/core/usecase"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

type mockRepository struct {
	styles []*domain.BeerStyle
	err    error
}

func (m *mockRepository) Create(style *domain.BeerStyle) (*domain.BeerStyle, error) {
	m.styles = append(m.styles, style)
	return style, nil
}

func (m *mockRepository) Update(style *domain.BeerStyle) (*domain.BeerStyle, error) {
	for i, s := range m.styles {
		if s.ID == style.ID {
			m.styles[i] = style
			return style, nil
		}
	}
	return nil, nil
}

func (m *mockRepository) Delete(id uuid.UUID) error {
	for i, s := range m.styles {
		if s.ID == id {
			m.styles = append(m.styles[:i], m.styles[i+1:]...)
			return nil
		}
	}
	return nil
}

func (m *mockRepository) GetByID(id uuid.UUID) (*domain.BeerStyle, error) {
	for _, s := range m.styles {
		if s.ID == id {
			return s, nil
		}
	}
	return nil, nil
}

func (m *mockRepository) GetAll() ([]*domain.BeerStyle, error) {
	return m.styles, m.err
}

func TestFindClosest(t *testing.T) {
	tests := []struct {
		name      string
		styles    []*domain.BeerStyle
		temp      float64
		wantStyle string
		wantErr   error
	}{
		{
			name: "encontra estilo mais próximo",
			styles: []*domain.BeerStyle{
				{ID: uuid.New(), Name: "Weissbier", MinTemperature: -1, MaxTemperature: 3},
				{ID: uuid.New(), Name: "Dunkel", MinTemperature: -8, MaxTemperature: 2},
			},
			temp:      -2,
			wantStyle: "Dunkel",
			wantErr:   nil,
		},
		{
			name: "desempate por ordem alfabética",
			styles: []*domain.BeerStyle{
				{ID: uuid.New(), Name: "Pilsens", MinTemperature: 0, MaxTemperature: 2},
				{ID: uuid.New(), Name: "IPA", MinTemperature: 0, MaxTemperature: 2},
			},
			temp:      1,
			wantStyle: "IPA",
			wantErr:   nil,
		},
		{
			name:      "nenhum estilo cadastrado",
			styles:    []*domain.BeerStyle{},
			temp:      5,
			wantStyle: "",
			wantErr:   usecase.ErrNoBeerStyles,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockRepository{styles: tt.styles}
			uc := usecase.NewBeerUseCase(repo)

			style, err := uc.FindClosest(tt.temp)

			if tt.wantErr != nil {
				assert.ErrorIs(t, err, tt.wantErr)
				assert.Nil(t, style)
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tt.wantStyle, style.Name)
			}
		})
	}
}
