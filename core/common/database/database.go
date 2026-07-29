package database

import (
	"os"

	"github.com/ra341/homework/common/fu"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

// InitDB initializes a SQLite database at the given path using the CGO-based SQLite variant.
// It configures the database to use Write-Ahead Logging (WAL) mode.
func InitDB(dbPath string) (*gorm.DB, error) {
	create, err := os.OpenFile(dbPath, os.O_CREATE, 0666)
	if err != nil {
		return nil, err
	}
	fu.CloseCloser(create)

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
