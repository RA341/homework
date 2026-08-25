package ytdlp

import (
	"strconv"

	"github.com/ra341/homework/internal/downloads"
)

type ProgressStr struct {
	Time  string `json:"time"`
	Speed string `json:"speed"`

	Downloaded string `json:"downloaded"`
	Total      string `json:"total"`

	Error string
}

func (p *ProgressStr) ToProgress(status downloads.DownloadState) *downloads.Progress {
	var err error
	prog := &downloads.Progress{
		Status: status,
	}

	timeSecs, err := strconv.ParseInt(p.Time, 10, 64)
	if err == nil {
		prog.TimeLeftSecs = uint(timeSecs)
	}

	speedFloat, err := strconv.ParseFloat(p.Speed, 64)
	if err == nil {
		prog.DownloadBytesPerSecond = uint(speedFloat)
	}

	bytesTotal, err := strconv.ParseInt(p.Total, 10, 64)
	if err == nil {
		prog.Total = uint(bytesTotal)
	}

	bytesDownloaded, err := strconv.ParseInt(p.Downloaded, 10, 64)
	if err == nil {
		prog.Completed = uint(bytesDownloaded)
	}

	return prog
}
