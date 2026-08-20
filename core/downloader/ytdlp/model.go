package ytdlp

import (
	"strconv"

	"github.com/ra341/homework/downloader/downloader"
)

type ProgressStr struct {
	Time  string
	Speed string

	Downloaded string
	Total      string

	Error string
}

func (p *ProgressStr) ToProgress(status downloader.DownloadStatus) *downloader.Progress {
	var err error
	prog := &downloader.Progress{
		Status: status,
	}

	timeSecs, err := strconv.ParseInt(p.Time, 10, 64)
	if err == nil {
		prog.TimeInSecs = timeSecs
	}

	speedFloat, err := strconv.ParseFloat(p.Speed, 64)
	if err == nil {
		prog.DownloadBytesSpeed = speedFloat
	}

	bytesTotal, err := strconv.ParseInt(p.Total, 10, 64)
	if err == nil {
		prog.Total = bytesTotal
	}

	bytesDownloaded, err := strconv.ParseInt(p.Downloaded, 10, 64)
	if err == nil {
		prog.Downloaded = bytesDownloaded
	}

	return prog
}
