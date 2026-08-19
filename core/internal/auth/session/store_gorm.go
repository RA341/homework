package session

import (
	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
}

func NewStore(db *gorm.DB) Store {
	return &StoreGorm{db: db}
}

func (s *StoreGorm) Create(session *Session) error {
	return s.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(session).Error; err != nil {
			return err
		}

		var activeIDs []uint
		const sessionLimit = 5
		if err := tx.Model(&Session{}).
			Where("user_id = ?", session.UserID).
			Order("id desc").
			Limit(sessionLimit).
			Pluck("id", &activeIDs).Error; err != nil {
			return err
		}

		if len(activeIDs) > 0 {
			err := tx.
				Where("user_id = ? AND id NOT IN ?", session.UserID, activeIDs).
				Unscoped().
				Delete(&Session{}).
				Error
			if err != nil {
				return err
			}
		}

		return nil
	})
}

func (s *StoreGorm) GetByID(id uint) (*Session, error) {
	dest := &Session{}
	err := s.db.Preload("User").First(dest, id).Error
	return dest, err
}

func (s *StoreGorm) GetByRefreshHashed(hashed string) (*Session, error) {
	dest := &Session{}
	err := s.db.Preload("User").Where("refresh_hashed = ?", hashed).First(dest).Error
	return dest, err
}

func (s *StoreGorm) Update(session *Session) error {
	return s.db.Save(session).Error
}

func (s *StoreGorm) Delete(id uint) error {
	return s.db.Delete(&Session{}, id).Error
}
