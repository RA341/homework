package downloads

import (
	"fmt"
	"sort"
	"sync"
	"time"
)

type TestStore struct {
	mu        sync.RWMutex
	downloads map[uint]Download
	nextID    uint
}

func (s *TestStore) Stats() (*DownloadStats, error) {
	//TODO implement me
	panic("implement me")
}

func (s *TestStore) SetProgress(id uint, status *Progress) error {
	//TODO implement me
	panic("implement me")
}

func (s *TestStore) EditLink(id int64, link string) error {
	//TODO implement me
	panic("implement me")
}

func NewTestStore() *TestStore {
	return &TestStore{
		downloads: make(map[uint]Download),
		nextID:    1,
	}
}

func (s *TestStore) ListQueued(limit int) ([]Download, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []Download
	for _, d := range s.downloads {
		if d.Progress.Status == Queued {
			result = append(result, d)
		}
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].ID < result[j].ID
	})

	if limit > 0 && len(result) > limit {
		result = result[:limit]
	}
	return result, nil
}

func (s *TestStore) AddDownload(download *Download) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.downloads == nil {
		s.downloads = make(map[uint]Download)
		s.nextID = 1
	}

	if download.ID == 0 {
		download.ID = s.nextID
		s.nextID++
	}
	if download.CreatedAt.IsZero() {
		download.CreatedAt = time.Now()
	}
	download.UpdatedAt = time.Now()

	s.downloads[download.ID] = *download
	return nil
}

func (s *TestStore) List(query string, after string, before string, limit uint) ([]Download, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []Download
	for _, d := range s.downloads {
		result = append(result, d)
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].ID < result[j].ID
	})

	if limit > 0 && uint(len(result)) > limit {
		result = result[:limit]
	}
	return result, nil
}

func (s *TestStore) Get(id uint) (Download, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	d, exists := s.downloads[id]
	if !exists {
		return Download{}, fmt.Errorf("download not found")
	}
	return d, nil
}

func (s *TestStore) SetDownloadErr(id uint, errStr string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	d, exists := s.downloads[id]
	if !exists {
		return fmt.Errorf("download not found")
	}
	d.Progress.Status = Error
	d.Progress.Error = errStr
	d.UpdatedAt = time.Now()
	s.downloads[id] = d
	return nil
}

func (s *TestStore) SetStatus(id uint, state DownloadState) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	d, exists := s.downloads[id]
	if !exists {
		return fmt.Errorf("download not found")
	}
	d.Progress.Status = state
	d.UpdatedAt = time.Now()
	s.downloads[id] = d
	return nil
}

func (s *TestStore) setProgress(id uint, status *Progress) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	d, exists := s.downloads[id]
	if !exists {
		return fmt.Errorf("download not found")
	}
	if status != nil {
		d.Progress = *status
	}
	d.UpdatedAt = time.Now()
	s.downloads[id] = d
	return nil
}
