package database

import (
	"context"
	"database/sql"
	"embed"
	"fmt"
	"io/fs"
	"os"

	"github.com/pressly/goose/v3"
	"github.com/ra341/homework/common/fu"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

//go:embed migrations/*.sql
var migrationsFS embed.FS

func InitDB(ctx context.Context, dbPath string) (*gorm.DB, error) {
	err := createDbFile(dbPath)
	if err != nil {
		return nil, err
	}

	err = migrate(ctx, dbPath)
	if err != nil {
		return nil, err
	}

	db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	// Enable Write-Ahead Logging (WAL) mode for better concurrency
	if err := db.Exec("PRAGMA journal_mode=WAL;").Error; err != nil {
		return nil, err
	}

	return db, nil
}

func createDbFile(dbPath string) error {
	fileHandle, err := os.OpenFile(dbPath, os.O_CREATE, 0666)
	if err != nil {
		return nil
	}
	fu.CloseCloser(fileHandle)
	return err
}

func migrate(ctx context.Context, dbPath string) error {
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		return fmt.Errorf("open sqlite: %w", err)
	}
	defer fu.CloseCloser(db)

	migrationDir, err := fs.Sub(migrationsFS, "migrations")
	if err != nil {
		return fmt.Errorf("could not open fs: %w", err)
	}

	logger := &GooseZerolog{logger: log.Logger}
	provider, err := goose.NewProvider(
		goose.DialectSQLite3,
		db,
		migrationDir,
		goose.WithLogger(logger),
	)
	if err != nil {
		return fmt.Errorf("could not create goose provider: %w", err)
	}
	defer fu.CloseCloser(provider)

	res, err := provider.Up(ctx)
	if err != nil {
		return fmt.Errorf("could not run migration: %w", err)
	}

	log.Debug().Any("res", res).Msg("ran migrations")

	return nil
}

type GooseZerolog struct {
	logger zerolog.Logger
}

func (g *GooseZerolog) Fatalf(format string, v ...any) {
	g.logger.Fatal().Msgf(format, v...)
}

func (g *GooseZerolog) Printf(format string, v ...any) {
	g.logger.Info().Msgf(format, v...)
}
