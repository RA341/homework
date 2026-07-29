package upload

import (
	"net/http"

	"github.com/ra341/homework/common/fu"
	"github.com/ra341/homework/internal/media/asset"
	"github.com/ra341/homework/internal/media/content"
)

type Handler struct {
	srv *Service
}

func NewHandler(srv *Service) (string, http.Handler) {
	han := Handler{srv: srv}

	mux := http.NewServeMux()
	mux.HandleFunc("/file", han.UploadFile)

	return "/upload", mux
}

func (h *Handler) UploadFile(w http.ResponseWriter, r *http.Request) {
	err := r.ParseMultipartForm(32 << 20)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	title := r.FormValue("title")
	desc := r.FormValue("desc")
	filename := r.FormValue("filename")
	assetTypeStr := r.FormValue("assetType")
	contentTypeStr := r.FormValue("contentType")
	assetRoleStr := r.FormValue("assetRole")

	assetType, err := asset.TypeString(assetTypeStr)
	if err != nil {
		http.Error(w, "invalid assetType: "+err.Error(), http.StatusBadRequest)
		return
	}

	assetRole, err := asset.RoleString(assetRoleStr)
	if err != nil {
		http.Error(w, "invalid assetType: "+err.Error(), http.StatusBadRequest)
		return
	}

	contentType, err := content.TypeString(contentTypeStr)
	if err != nil {
		http.Error(w, "invalid contentType: "+err.Error(), http.StatusBadRequest)
		return
	}

	file, head, err := r.FormFile("uploadFile")
	if err != nil {
		http.Error(w, "missing uploadFile: "+err.Error(), http.StatusBadRequest)
		return
	}
	defer fu.CloseCloser(file)

	if filename == "" {
		filename = head.Filename
	}

	err = h.srv.Upload(
		title,
		desc,
		filename,
		contentType,
		assetType,
		assetRole,
		file,
	)
	if err != nil {
		http.Error(w, "Error uploading file: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}
