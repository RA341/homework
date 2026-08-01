package downloader

import (
	"log"
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/ra341/homework/common/fu"
)

// unimplemented for now since los are not really needed right now
// since logs only have the speed and downloaded bytes info which is already tracked by progress check
// and any errors are should be set in the error field of progress

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true }, // todo load from config dev only
}

type HandlerHttp struct {
	srv *Service
}

func NewHandlerHttp(srv *Service) (string, http.Handler) {
	h := HandlerHttp{
		srv: srv,
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/logs", h.wsHandler)

	return "/downloader", mux
}

func (h *HandlerHttp) wsHandler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade error:", err)
		return
	}
	defer fu.CloseCloser(conn)

	for {
		msgType, msg, err := conn.ReadMessage()
		if err != nil {
			log.Println("read error:", err)
			break
		}
		log.Printf("received: %s", msg)

		if err := conn.WriteMessage(msgType, msg); err != nil {
			log.Println("write error:", err)
			break
		}
	}
}
