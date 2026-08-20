package cli

import (
	"bytes"
	"fmt"
	"os/exec"
)

// Check checks for existence of a particular cli by calling --help
func Check(name string) error {
	cmd := exec.Command(name, "--help")

	var stderrBuf bytes.Buffer
	cmd.Stderr = &stderrBuf

	err := cmd.Start()
	if err != nil {
		return fmt.Errorf("could not access yt-dlp: %v", err)
	}

	return nil
}
