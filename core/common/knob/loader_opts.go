package knob

import (
	"fmt"
	"maps"
	"reflect"
	"time"
)

type Opt func(l *Loader)

func WithValueLoaders(loaders ...ValueLoader) Opt {
	return func(l *Loader) {
		l.ValueLoaders = append(l.ValueLoaders, loaders...)
	}
}

func WithEnvPrefixer(prefix EnvPrefixer) Opt {
	return func(l *Loader) {
		l.EnvPrefixer = prefix
	}
}

// WithTypeMappers loads any custom type mapper, overrides any previous type mappers that may have been set
func WithTypeMappers(mapper map[reflect.Type]TypeMapFn) Opt {
	return func(l *Loader) {
		l.TypeMapper = mapper
	}
}

// WithTypeMappersMerge merges values into existing type mappers, any conflicting values will be overwritten by the new map
func WithTypeMappersMerge(mapper map[reflect.Type]TypeMapFn) Opt {
	return func(l *Loader) {
		maps.Copy(l.TypeMapper, mapper)
	}
}

func DefaultMappers() map[reflect.Type]TypeMapFn {
	return map[reflect.Type]TypeMapFn{
		reflect.TypeFor[[]byte](): func(rv reflect.Value, value string, ele *Element) error {
			rv.SetBytes([]byte(value))
			return nil
		},
		reflect.TypeFor[time.Duration](): func(rv reflect.Value, value string, ele *Element) error {
			duration, err := time.ParseDuration(value)
			if err != nil {
				return fmt.Errorf("%s = invalid duration str: %s", ele.Path, err)
			}

			rv.Set(reflect.ValueOf(duration))
			return nil
		},
	}
}
