package knob

import (
	"fmt"
	"reflect"
)

type Functor func(rv reflect.Value, element *Element, tagValue string) error

type Knob struct {
	functor Functor
}

// walkStruct recursively visits every field of a struct (or pointer to struct),
// including nested structs, slices/arrays of structs, and maps with struct values.
func (k *Knob) walkStruct(v any, path string) error {
	rv := reflect.ValueOf(v)
	if rv.Kind() != reflect.Pointer {
		return fmt.Errorf("value must be a pointer to allow assignment")
	}

	return k.walkValue(rv, nil, path)
}

func (k *Knob) walkValue(rv reflect.Value, sf *reflect.StructField, path string) (err error) {
	// unwrap pointers
	for rv.Kind() == reflect.Pointer {
		if rv.IsNil() {
			fmt.Printf("%s = <nil>\n", path)
			return nil
		}
		rv = rv.Elem()
	}

	switch rv.Kind() {
	case reflect.Struct:
		t := rv.Type()
		for i := 0; i < rv.NumField(); i++ {
			field := t.Field(i)
			fv := rv.Field(i)

			fieldPath := field.Name
			if path != "" {
				fieldPath = path + "." + field.Name
			}

			if !fv.CanInterface() { // unexported field
				//fmt.Printf("%s = <unexported>\n", fieldPath)
				continue
			}

			err = k.walkValue(fv, &field, fieldPath)
			if err != nil {
				return err
			}
		}

	default:
		if sf == nil {
			fmt.Println("no struct value found to load tags from", path)
			return nil
		}

		const KnobStructKey = "knob"
		tagValue, ok := sf.Tag.Lookup(KnobStructKey)
		if !ok {
			fmt.Println("field does not have knob tag", path)
			return nil
		}

		knobElement := &Element{
			Path: path,
		}

		err = knobElement.load(tagValue)
		if err != nil {
			return fmt.Errorf("could not parse tag: %w", err)
		}

		err = k.functor(rv, knobElement, tagValue)
		if err != nil {
			return err
		}
	}

	return nil
}
