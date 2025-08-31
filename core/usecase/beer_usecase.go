package usecase

import (
	"errors"
	"math"
	"sort"

	"github.com/GoLogann/karhub-beer/adapter/repository"
	"github.com/GoLogann/karhub-beer/domain"
	"github.com/google/uuid"
)

var (
	ErrNoBeerStyles = errors.New("no beer styles registered")
)

type BeerUsecaseInterface interface {
	Create(*domain.BeerStyle) (*domain.BeerStyle, error)
	Update(*domain.BeerStyle) (*domain.BeerStyle, error)
	Delete(uuid.UUID) error
	GetByID(uuid.UUID) (*domain.BeerStyle, error)
	GetAll() ([]*domain.BeerStyle, error)
	FindClosest(float64) (*domain.BeerStyle, error)
}

type BeerUseCase struct {
	repo repository.BeerRepository
}

func NewBeerUseCase(repo repository.BeerRepository) *BeerUseCase {
	return &BeerUseCase{repo: repo}
}

var _ BeerUsecaseInterface = (*BeerUseCase)(nil)

func (uc *BeerUseCase) Create(style *domain.BeerStyle) (*domain.BeerStyle, error) {
	return uc.repo.Create(style)
}

func (uc *BeerUseCase) Update(style *domain.BeerStyle) (*domain.BeerStyle, error) {
	return uc.repo.Update(style)
}

func (uc *BeerUseCase) Delete(id uuid.UUID) error {
	return uc.repo.Delete(id)
}

func (uc *BeerUseCase) GetByID(id uuid.UUID) (*domain.BeerStyle, error) {
	return uc.repo.GetByID(id)
}

func (uc *BeerUseCase) GetAll() ([]*domain.BeerStyle, error) {
	return uc.repo.GetAll()
}

func (uc *BeerUseCase) FindClosest(temp float64) (*domain.BeerStyle, error) {
	styles, err := uc.repo.GetAll()
	if err != nil {
		return nil, err
	}
	if len(styles) == 0 {
		return nil, ErrNoBeerStyles
	}

	type candidate struct {
		style    *domain.BeerStyle
		distance float64
	}
	var candidates []candidate

	for _, st := range styles {
		dist := math.Abs(temp - st.AvgTemperature())
		candidates = append(candidates, candidate{style: st, distance: dist})
	}

	sort.Slice(candidates, func(i, j int) bool {
		if candidates[i].distance == candidates[j].distance {
			return candidates[i].style.Name < candidates[j].style.Name
		}
		return candidates[i].distance < candidates[j].distance
	})

	return candidates[0].style, nil
}