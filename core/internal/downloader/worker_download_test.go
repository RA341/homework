package downloader

import (
	"fmt"
	"math/rand"
	"sync"
	"testing"
	"time"

	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
	"gorm.io/gorm"
)

func TestNewDownloadWorker(t *testing.T) {
	downloadStore := NewInMemoryDownloadStore()
	downloader := NewRandomSleepDownloader(downloadStore)

	maxWorkers := 10
	threshold := 20
	worker := NewDownloadWorker(maxWorkers, threshold, downloadStore, downloader)

	downloadStore.Add(10)
	worker.Start()

	//for range 5 {
	//	// keep adding 10 downloads
	//	time.After(2 * time.Second)
	//	downloadStore.Add(10)
	//}

	worker.wait()

	complete := downloadStore.AllComplete()
	require.Nil(t, complete)
}

type RandomSleepDownloader struct {
	store DownloadStore
}

func NewRandomSleepDownloader(store DownloadStore) *RandomSleepDownloader {
	return &RandomSleepDownloader{store: store}
}

func (d *RandomSleepDownloader) download(dl *Download) {
	id := dl.ID
	sleepSecs := rand.Intn(26) + 5 // 5-30 inclusive
	time.After(time.Duration(sleepSecs) * time.Second)

	_ = d.store.SetStatus(id, Complete)

	log.Info().Int("id", int(id)).Msg("download complete")
}

// InMemoryDownloadStore is a fake store backed by a slice, seeded with
// randomly generated queued downloads. IDs are the slice indexes.
type InMemoryDownloadStore struct {
	mu        sync.Mutex
	downloads []Download
}

func NewInMemoryDownloadStore() *InMemoryDownloadStore {
	return &InMemoryDownloadStore{}
}

func (s *InMemoryDownloadStore) AllComplete() *Download {
	s.mu.Lock()
	defer s.mu.Unlock()

	for _, d := range s.downloads {
		if d.Status != Complete {
			return &d
		}
	}
	return nil
}

func (s *InMemoryDownloadStore) Add(count int) {
	s.mu.Lock()
	defer s.mu.Unlock()

	for i := range count {
		id := uint(i)
		s.downloads = append(s.downloads, Download{
			Model:        gormModelWithID(id),
			AssetID:      id + 1,
			Name:         fmt.Sprintf("asset-%d.bin", id),
			DownloadLink: fmt.Sprintf("https://example.com/downloads/%d", id),
			Status:       Queued,
			Progress:     DownloadProgress{},
		})
	}
}

func (s *InMemoryDownloadStore) ListQueued(limit int) ([]Download, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	result := make([]Download, 0, limit)
	for _, d := range s.downloads {
		if d.Status == Queued {
			result = append(result, d)
			if len(result) == limit {
				break
			}
		}
	}
	return result, nil
}

// SetStatus indexes directly into the slice: id == index.
func (s *InMemoryDownloadStore) SetStatus(id uint, state DownloadState) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if int(id) >= len(s.downloads) {
		return fmt.Errorf("download id %d out of range", id)
	}
	s.downloads[id].Status = state
	return nil
}

// helper since gorm.Model.ID is unexported-by-convention but public field
func gormModelWithID(id uint) gorm.Model {
	return gorm.Model{ID: id}
}
