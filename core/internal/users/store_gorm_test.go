package users

import (
	"testing"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func TestStoreGorm(t *testing.T) {
	db, err := gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open database: %v", err)
	}

	if err := db.AutoMigrate(&User{}); err != nil {
		t.Fatalf("failed to migrate database: %v", err)
	}

	store := NewStore(db)

	t.Run("Create and List", func(t *testing.T) {
		user := &User{
			Username:       "alice",
			HashedPassword: "passwordhash",
		}

		err := store.Create(user)
		if err != nil {
			t.Fatalf("failed to create user: %v", err)
		}

		if user.ID == 0 {
			t.Error("expected non-zero ID for created user")
		}

		list, err := store.List()
		if err != nil {
			t.Fatalf("failed to list users: %v", err)
		}

		if len(list) != 1 {
			t.Errorf("expected 1 user, got %d", len(list))
		}

		if list[0].Username != "alice" {
			t.Errorf("expected username alice, got %s", list[0].Username)
		}
	})

	t.Run("Edit User", func(t *testing.T) {
		user := &User{
			Username:       "bob",
			HashedPassword: "bobhash",
		}

		err := store.Create(user)
		if err != nil {
			t.Fatalf("failed to create user: %v", err)
		}

		user.Username = "bobby"
		err = store.Edit(user)
		if err != nil {
			t.Fatalf("failed to edit user: %v", err)
		}

		list, err := store.List()
		if err != nil {
			t.Fatalf("failed to list users: %v", err)
		}

		// Find bob in the list
		var found bool
		for _, u := range list {
			if u.ID == user.ID {
				found = true
				if u.Username != "bobby" {
					t.Errorf("expected username bobby, got %s", u.Username)
				}
			}
		}
		if !found {
			t.Error("edited user not found in list")
		}
	})

	t.Run("Delete User", func(t *testing.T) {
		user := &User{
			Username:       "charlie",
			HashedPassword: "charliehash",
		}

		err := store.Create(user)
		if err != nil {
			t.Fatalf("failed to create user: %v", err)
		}

		err = store.Delete(user.ID)
		if err != nil {
			t.Fatalf("failed to delete user: %v", err)
		}

		list, err := store.List()
		if err != nil {
			t.Fatalf("failed to list users: %v", err)
		}

		for _, u := range list {
			if u.ID == user.ID {
				t.Errorf("user with ID %d was not deleted", user.ID)
			}
		}
	})
}
