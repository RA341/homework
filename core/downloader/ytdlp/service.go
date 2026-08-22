package ytdlp

import (
	"bufio"
	"bytes"
	"encoding/json/v2"
	"fmt"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/ra341/homework/common/cli"
	"github.com/ra341/homework/downloader/downloader"
)

type Service struct {
	browserData string
}

func NewService(browserData string) (*Service, error) {
	s := &Service{
		browserData: browserData,
	}
	err := s.init()
	return s, err
}

func (yt *Service) init() error {
	var clis = []string{"yt-dlp", "deno", "ffmpeg", "ffprobe"}
	for _, c := range clis {
		err := cli.Check(c)
		if err != nil {
			return fmt.Errorf("error checking %s: %w", c, err)
		}
	}

	return nil
}

func (yt *Service) Download(item *downloader.DownloadItem, setProgress func(p *downloader.Progress)) {
	var resp ProgressStr

	defer func() {
		if resp.Error == "" {
			setProgress(resp.ToProgress(downloader.Complete))
		} else {
			setProgress(resp.ToProgress(downloader.Error))
		}
	}()

	progressFmt := `{"status":"%(progress.status)s", "time":"%(progress.eta)s","speed":"%(progress.speed)s","downloaded":"%(progress.downloaded_bytes)s","total":"%(progress.total_bytes)s"}`
	outputPath := filepath.Join(item.DownloadFolder, "%(title)s.%(ext)s")
	args := []string{
		"--newline",
		"--progress-template",
		progressFmt,
		"--cookies-from-browser", fmt.Sprintf("chrome:%s/.config/chromium", yt.browserData),
		"--impersonate", "chrome",
		"-o", outputPath,
		item.Url,
	}

	cmd := exec.CommandContext(item.Ctx, "yt-dlp", args...)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		resp.Error = err.Error()
		return
	}

	var stderrBuf bytes.Buffer
	cmd.Stderr = &stderrBuf

	err = cmd.Start()
	if err != nil {
		resp.Error = err.Error()
		return
	}

	scanner := bufio.NewScanner(stdout)
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(line)

		prefix := strings.HasPrefix(line, "{")
		if !prefix {
			fmt.Println(line)
			continue
		}

		err = json.Unmarshal([]byte(line), &resp)
		if err != nil {
			fmt.Println("could not parse line", line)
			continue
		}

		setProgress(resp.ToProgress(downloader.Downloading))
	}

	err = cmd.Wait()
	if err != nil {
		resp.Error = stderrBuf.String()
		return
	}
}
