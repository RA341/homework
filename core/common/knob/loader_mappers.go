package knob

import (
	"fmt"
	"reflect"
	"time"
)

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
