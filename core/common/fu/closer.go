// Package fu provides (f)ile (u)tils for io interfaces
package fu

import (
	"io"

	"github.com/rs/zerolog/log"
)

func CloseCloser(item io.Closer) {
	err := item.Close()
	if err != nil {
		log.Warn().Err(err).Msg("Error closing closer")
	}
}
