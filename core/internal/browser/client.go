package browser

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/ra341/homework/common/fu"
)

type Response struct {
	Status    string   `json:"status"`
	Message   string   `json:"message,omitempty"`
	Running   bool     `json:"running,omitempty"`
	RawStatus string   `json:"raw_status,omitempty"`
	Errors    []string `json:"errors,omitempty"`
}

type ClientConfig interface {
	BaseUrl() string
}

type ChromtrolClient struct {
	conf ClientConfig
	HTTP *http.Client
}

func NewClient(conf ClientConfig) *ChromtrolClient {
	return &ChromtrolClient{
		conf: conf,
		HTTP: &http.Client{Timeout: 3 * time.Second},
	}
}

func (c *ChromtrolClient) Start(ctx context.Context) (*Response, int, error) {
	return c.do(ctx, http.MethodPost, "/start")
}

func (c *ChromtrolClient) Stop(ctx context.Context) (*Response, int, error) {
	return c.do(ctx, http.MethodPost, "/stop")
}

func (c *ChromtrolClient) Status(ctx context.Context) (*Response, int, error) {
	return c.do(ctx, http.MethodGet, "/status")
}

func (c *ChromtrolClient) do(ctx context.Context, method, path string) (*Response, int, error) {
	req, err := http.NewRequestWithContext(ctx, method, c.conf.BaseUrl()+path, nil)
	if err != nil {
		return nil, 0, err
	}

	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, 0, err
	}
	defer fu.CloseCloser(resp.Body)

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, resp.StatusCode, err
	}

	var r Response
	if err := json.Unmarshal(body, &r); err != nil {
		return nil, resp.StatusCode, fmt.Errorf("decode failed: %w (body: %s)", err, string(body))
	}
	return &r, resp.StatusCode, nil
}
