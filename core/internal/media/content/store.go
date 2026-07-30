package content

import "github.com/ra341/homework/common/pagination"

type Store interface {
	Create(title, desc string, contentType Type) (Content, error)
	List(query string, after, before, limit uint) (pagination.Result[Content], error)
}
