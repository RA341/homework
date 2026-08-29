package knob

import (
	"maps"
	"reflect"
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
