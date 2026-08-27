package knob

import (
	"errors"
	"fmt"
	"reflect"
	"strconv"
	"strings"
)

type Functor func(rv reflect.Value, element *Element, tagValue string) error

type Element struct {
	Default  string
	Env      string
	Required bool
	Help     string
	Secret   bool
	Path     string
}

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

	//case reflect.Slice, reflect.Array:
	//	for i := 0; i < rv.Len(); i++ {
	//		k.walkValue(rv.Index(i), nil, fmt.Sprintf("%s[%d]", path, i))
	//	}
	//
	//case reflect.Map:
	//	for _, key := range rv.MapKeys() {
	//		k.walkValue(rv.MapIndex(key), nil, fmt.Sprintf("%s[%v]", path, key.Interface()))
	//	}

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
		err = k.parseTag(tagValue, knobElement)
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

func (k *Knob) parseTag(tagValue string, ke *Element) error {
	keyMap := make(map[string]string)
	err := k.loadKeymap(tagValue, keyMap)
	if err != nil {
		return err
	}

	for key, val := range keyMap {
		switch key {
		case "default":
			ke.Default = val
		case "env":
			ke.Env = val
		case "help":
			ke.Help = val
		case "required":
			parseBool, _ := strconv.ParseBool(val)
			ke.Required = parseBool
		case "secret":
			parseBool, _ := strconv.ParseBool(val)
			ke.Secret = parseBool
		default:
			return fmt.Errorf("unsupported key %s", key)
		}
	}

	return nil
}

func (k *Knob) loadKeymap(tagValue string, keyMap map[string]string) error {
	tagValue = strings.TrimSpace(tagValue)
	keyvalues := strings.SplitSeq(tagValue, ",")

	var errs error
	for v := range keyvalues {
		if v == "" {
			continue
		}

		splitV := strings.Split(v, "=")
		if len(splitV) != 2 {
			err := fmt.Errorf("invalid attr: %s expected len 2 after split, got %d", splitV, len(splitV))
			errs = errors.Join(errs, err)
			continue
		}

		key := strings.ToLower(strings.TrimSpace(splitV[0]))
		value := strings.TrimSpace(splitV[1])
		keyMap[key] = value
	}

	return errs
}
