package pick

import (
	"os"
	"reflect"
)

type AllowedTypes interface {
	int | string
}

type Pick[T AllowedTypes] struct {
}

func Pk[T AllowedTypes]() *Pick[T] {
	return &Pick[T]{}
}

func (p *Pick[T]) Env(envName string) Env[T] {
	return Env[T]{
		EnvName: envName,
	}
}

type Env[T AllowedTypes] struct {
	EnvName string
	Value   T
}

func (e Env[T]) GetOrDefault(defaultV T) T {
	val := os.Getenv(e.EnvName)
	if val == "" {
		return defaultV
	}

	var zero T
	targetType := reflect.TypeOf(zero)

	converted := reflect.ValueOf(val).Convert(targetType)

	return converted.Interface().(T)
}
