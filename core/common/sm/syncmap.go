package sm

import "sync"

// Map is a type-safe wrapper around sync.Map.
type Map[K comparable, V any] struct {
	m sync.Map
}

func (m *Map[K, V]) Load(key K) (V, bool) {
	v, ok := m.m.Load(key)
	if !ok {
		var zero V
		return zero, false
	}
	return v.(V), true
}

func (m *Map[K, V]) Store(key K, value V) {
	m.m.Store(key, value)
}

func (m *Map[K, V]) LoadOrStore(key K, value V) (V, bool) {
	v, loaded := m.m.LoadOrStore(key, value)
	return v.(V), loaded
}

func (m *Map[K, V]) LoadAndDelete(key K) (V, bool) {
	v, loaded := m.m.LoadAndDelete(key)
	if !loaded {
		var zero V
		return zero, false
	}
	return v.(V), true
}

func (m *Map[K, V]) Delete(key K) {
	m.m.Delete(key)
}

func (m *Map[K, V]) Swap(key K, value V) (V, bool) {
	prev, loaded := m.m.Swap(key, value)
	if !loaded {
		var zero V
		return zero, false
	}
	return prev.(V), true
}

func (m *Map[K, V]) CompareAndSwap(key K, old, new V) bool {
	return m.m.CompareAndSwap(key, old, new)
}

func (m *Map[K, V]) CompareAndDelete(key K, old V) bool {
	return m.m.CompareAndDelete(key, old)
}

func (m *Map[K, V]) Range(f func(key K, value V) bool) {
	m.m.Range(func(k, v any) bool {
		return f(k.(K), v.(V))
	})
}
