package postgres

import (
	"os"

	"github.com/sirupsen/logrus"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/plugin/opentelemetry/tracing"
)

var DB *gorm.DB

func InitDB() *gorm.DB {
	logrus.SetLevel(logrus.InfoLevel)
	logrus.SetFormatter(&logrus.TextFormatter{FullTimestamp: true})

	logrus.Info("Connecting to PostgreSQL...")

	dsn := "host=" + os.Getenv("DB_HOST") +
		" user=" + os.Getenv("DB_USER") +
		" password=" + os.Getenv("DB_PASSWORD") +
		" dbname=" + os.Getenv("DB_NAME") +
		" port=" + os.Getenv("DB_PORT") +
		" sslmode=" + os.Getenv("DB_SSLMODE") +
		" TimeZone=" + os.Getenv("DB_TIMEZONE") +
		" connect_timeout=" + os.Getenv("DB_CONNECT_TIMEOUT")

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		logrus.WithFields(logrus.Fields{
			"host":     os.Getenv("DB_HOST"),
			"user":     os.Getenv("DB_USER"),
			"database": os.Getenv("DB_NAME"),
		}).WithError(err).Fatal("Failed to connect to database")
	}

	if err := db.Use(tracing.NewPlugin()); err != nil {
		logrus.WithError(err).Warn("Falha ao habilitar OpenTelemetry no GORM")
	}

	logrus.Info("Database connected successfully with OpenTelemetry tracing")
	DB = db
	return DB
}
