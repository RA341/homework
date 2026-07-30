package content

import (
	"github.com/ra341/homework/common/pagination"
	"gorm.io/gorm"
)

type StoreGorm struct {
	db *gorm.DB
}

func NewStore(db *gorm.DB) Store {
	return &StoreGorm{db: db}
}

// List after, before is ignored if query is passed
func (s *StoreGorm) List(query string, after, before, limit uint) (pagination.Result[Content], error) {
	var count int64
	countTx := s.db.Model(&Content{})
	if query != "" {
		likePattern := "%" + query + "%"
		countTx = countTx.Where("title LIKE ? OR description LIKE ?", likePattern, likePattern)
	}
	if err := countTx.Count(&count).Error; err != nil {
		return pagination.Result[Content]{}, err
	}

	tx := s.db.Model(&Content{})
	if query != "" {
		likePattern := "%" + query + "%"
		tx = tx.Where("title LIKE ? OR description LIKE ?", likePattern, likePattern)
		tx = tx.Order("id ASC")
	} else {
		if after > 0 {
			tx = tx.Where("id > ?", after).Order("id ASC")
		} else if before > 0 {
			tx = tx.Where("id < ?", before).Order("id DESC")
		} else {
			tx = tx.Order("id ASC")
		}
	}

	if limit > 0 {
		tx = tx.Limit(int(limit))
	}

	var results []Content
	if err := tx.Find(&results).Error; err != nil {
		return pagination.Result[Content]{}, err
	}

	if query == "" && before > 0 {
		for i, j := 0, len(results)-1; i < j; i, j = i+1, j-1 {
			results[i], results[j] = results[j], results[i]
		}
	}

	var firstID, lastID uint
	if len(results) > 0 {
		firstID = results[0].ID
		lastID = results[len(results)-1].ID
	}

	return pagination.Result[Content]{
		Results: results,
		After:   lastID,
		Before:  firstID,
		Count:   uint(count),
	}, nil
}

func (s *StoreGorm) Create(title, desc string, contentType Type) (Content, error) {
	content := Content{
		Title:       title,
		Description: desc,
		Type:        contentType,
	}
	if err := s.db.Create(&content).Error; err != nil {
		return Content{}, err
	}
	return content, nil
}
