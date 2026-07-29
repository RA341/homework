package pagination

type Pagintion[T any] struct {
	Results []T
	After   uint
	Before  uint
	Count   uint
}
