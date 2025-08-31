package trace

import (
	"context"
	"os"

	"github.com/GoLogann/karhub-beer/infra/observability"
	"go.uber.org/fx"
)

func TracerModule() fx.Option {
	return fx.Options(
		fx.Invoke(func(lc fx.Lifecycle) {
			shutdown := observability.NewTracer(observability.TracerConfig{
				ServiceName: os.Getenv("OTEL_SERVICE_NAME"),
				Endpoint:    os.Getenv("OTEL_EXPORTER_OTLP_ENDPOINT"),
			})

			lc.Append(fx.Hook{
				OnStop: func(ctx context.Context) error {
					return shutdown(ctx)
				},
			})
		}),
	)
}