package downloader

import (
	"errors"
	"fmt"
	"math/rand"
	"strconv"
	"sync"
	"testing"
	"time"
)

type downloadInfo struct {
	startTime time.Time
	isSuccess bool
}

func TestServiceDownloads(t *testing.T) {
	// 1. Initialize TestStore
	store := NewTestStore()

	// 2. Initialize TestDownloader
	cli := &TestDownloader{}

	// 3. Initialize Config
	conf := &Config{
		SocketPath:             DefaultSocket,
		DownloadsDir:           "/tmp/downloads",
		ProgressCheckThreshold: 5,
		CheckIntervalSecs:      1,
		MaxDownloads:           20,
	}

	// 4. Initialize Service
	s, err := NewService(conf, store, cli)
	if err != nil {
		t.Fatalf("failed to create service: %v", err)
	}

	// 5. Queue 20 random downloads in 5 seconds intervals 3 times
	const Batch = 2
	const DownloadSize = 10
	totalDownloads := Batch * DownloadSize

	for batch := range Batch {
		t.Logf("Queueing batch %d of 20 downloads...", batch+1)
		for i := range DownloadSize {
			name := fmt.Sprintf("video_batch_%d_%d", batch, i)
			link := fmt.Sprintf("http://example.com/video_%d_%d.mp4", batch, i)
			path := fmt.Sprintf("/tmp/downloads/video_%d_%d.mp4", batch, i)
			err := s.Add(name, link, path)
			if err != nil {
				t.Fatalf("failed to add download: %v", err)
			}
		}
		// Only sleep if it's not the last batch
		if batch < 2 {
			<-time.After(5 * time.Second)
		}
	}

	// Wait for worker to finish
	t.Log("All downloads sent. Waiting for workerRunning to be false...")

	// Make sure worker had some time to pick up/start if needed
	<-time.After(500 * time.Millisecond)

	for s.workerRunning {
		<-time.After(100 * time.Millisecond)
	}

	t.Log("Worker stopped. Verifying download statuses...")

	// Check download statuses in store
	downloads, err := store.List("", "", "", uint(totalDownloads))
	if err != nil {
		t.Fatalf("failed to list downloads: %v", err)
	}

	if len(downloads) != totalDownloads {
		t.Errorf("expected %d downloads, got %d", totalDownloads, len(downloads))
	}

	for _, d := range downloads {
		t.Logf("Download ID: %d, Name: %s, Status: %v, Error: %s", d.ID, d.Name, d.Status, d.Progress.Error)
		if d.Status != Complete && d.Status != Error {
			t.Errorf("download %d (%s) has invalid status: %v", d.ID, d.Name, d.Status)
		}
	}
}

type TestDownloader struct {
	mu        sync.Mutex
	downloads map[string]downloadInfo
}

func (t *TestDownloader) download(video string, downloadPath string) (downloadId string, err error) {
	<-time.After(500 * time.Millisecond)
	id := strconv.Itoa(rand.Intn(1000000000))

	t.mu.Lock()
	if t.downloads == nil {
		t.downloads = make(map[string]downloadInfo)
	}
	t.downloads[id] = downloadInfo{
		startTime: time.Now(),
		isSuccess: rand.Intn(2) == 0,
	}
	t.mu.Unlock()

	return id, nil
}

func (t *TestDownloader) progress(id string) (DownloadState, *DownloadProgress, error) {
	<-time.After(500 * time.Millisecond)

	t.mu.Lock()
	info, exists := t.downloads[id]
	t.mu.Unlock()

	if !exists {
		return Error, nil, errors.New("download not found")
	}

	elapsed := time.Since(info.startTime)
	if elapsed >= 5*time.Second {
		if info.isSuccess {
			return Complete, &DownloadProgress{
				TimeLeftSecs:           0,
				DownloadBytesPerSecond: 0,
				Complete:               100,
				Left:                   0,
				Error:                  "",
			}, nil
		}

		return Error, &DownloadProgress{
			TimeLeftSecs:           0,
			DownloadBytesPerSecond: 0,
			Complete:               0,
			Left:                   100,
			Error:                  "download failed randomly",
		}, errors.New("download failed randomly")
	}

	// Calculate simulated progress
	percent := min(uint(elapsed.Seconds()/5.0*100), 99)

	return Downloading, &DownloadProgress{
		TimeLeftSecs:           uint(5 - elapsed.Seconds()),
		DownloadBytesPerSecond: 1024 * 1024,
		Complete:               percent,
		Left:                   100 - percent,
		Error:                  "",
	}, nil
}
