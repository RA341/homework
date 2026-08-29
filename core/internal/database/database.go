package database

import (
	"context"
	"database/sql"
	"embed"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/pressly/goose/v3"
	"github.com/ra341/homework/common/fu"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

//go:embed migrations/*.sql
var migrationsFS embed.FS

type Database struct {
	conf   *Config
	GormDB *gorm.DB
}

func NewDatabase(ctx context.Context, conf *Config) (*Database, error) {
	d := &Database{
		conf: conf,
	}
	err := d.Init(ctx)
	return d, err
}

func (d *Database) Init(ctx context.Context) (err error) {
	const dbFile = "hw.db"

	dbPath := filepath.Join(d.conf.DatabaseDir, dbFile)
	err = createDbFile(dbPath)
	if err != nil {
		return err
	}

	err = migrate(ctx, dbPath)
	if err != nil {
		return err
	}

	opts := &gorm.Config{
		Logger: logger.Default.LogMode(logger.Warn),
	}
	db, err := gorm.Open(sqlite.Open(dbPath), opts)
	if err != nil {
		return err
	}

	// Enable Write-Ahead Logging (WAL) mode for better concurrency
	err = db.Exec("PRAGMA journal_mode=WAL;").Error
	if err != nil {
		return err
	}

	d.GormDB = db
	return nil
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

	gooseLog := &GooseZerolog{logger: log.Logger}
	provider, err := goose.NewProvider(
		goose.DialectSQLite3,
		db,
		migrationDir,
		goose.WithLogger(gooseLog),
	)
	if err != nil {
		return fmt.Errorf("could not create goose provider: %w", err)
	}
	defer fu.CloseCloser(provider)

	_, err = provider.Up(ctx)
	if err != nil {
		return fmt.Errorf("could not run migration: %w", err)
	}

	//log.Debug().Any("res", res).Msg("ran migrations")

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
