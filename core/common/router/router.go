package router

import (
	"net/http"
	"strings"
)

type Router struct {
	ParentMux *http.ServeMux
}

// AddRouter registers a childMux under path on parentMux, stripping the prefix.
func (r *Router) AddRouter(path string, childMux http.Handler) {
	pattern := path
	if pattern == "" {
		pattern = "/"
	}
	if pattern != "/" && !strings.HasSuffix(pattern, "/") {
		pattern = pattern + "/"
	}

	prefix := strings.TrimSuffix(path, "/")

	var handler = childMux
	if prefix != "" && prefix != "/" {
		handler = http.StripPrefix(prefix, childMux)
	}

	r.ParentMux.Handle(pattern, handler)
}

// AddHandler registers a handler under path on parentMux without stripping the prefix.
func (r *Router) AddHandler(path string, handler http.Handler) {
	pattern := path
	if pattern == "" {
		pattern = "/"
	}
	if pattern != "/" && !strings.HasSuffix(pattern, "/") {
		pattern = pattern + "/"
	}

	r.ParentMux.Handle(pattern, handler)
}
