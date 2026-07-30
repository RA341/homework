package pagination

type Result[T any] struct {
	Results []T
	After   uint
	Before  uint
	Count   uint
}

type Pagination[T any] interface {
	List(query string, after, before, limit uint) (Result[T], error)
}
