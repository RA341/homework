package app

import (
	"errors"
	"fmt"
	"os"
	"reflect"
	"strconv"
	"strings"
	"time"
)

type Prefixer func(string) string

type Knob struct {
	prefixer Prefixer
}

// WalkStruct recursively visits every field of a struct (or pointer to struct),
// including nested structs, slices/arrays of structs, and maps with struct values.
func (k *Knob) WalkStruct(v any, path string) error {
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
				fmt.Printf("%s = <unexported>\n", fieldPath)
				continue
			}

			//jsonTag := field.Tag.Get("json")         // "name" or "" if absent
			//validateTag := field.Tag.Get("validate") // "required" or ""

			//fmt.Printf("field=%s json=%q validate=%q\n", field.Name, jsonTag, validateTag)
			err = k.walkValue(fv, &field, fieldPath)
			if err != nil {
				return err
			}
		}

	case reflect.Slice, reflect.Array:
		for i := 0; i < rv.Len(); i++ {
			k.walkValue(rv.Index(i), nil, fmt.Sprintf("%s[%d]", path, i))
		}

	case reflect.Map:
		for _, key := range rv.MapKeys() {
			k.walkValue(rv.MapIndex(key), nil, fmt.Sprintf("%s[%v]", path, key.Interface()))
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

		knobElement := &KnobElement{
			path: path,
		}
		err = k.parseTag(tagValue, knobElement)
		if err != nil {
			return fmt.Errorf("could not parse tag: %w", err)
		}

		err = k.assignValue(rv, knobElement, tagValue)
		if err != nil {
			return err
		}

		// base value: string, int, bool, float, etc.
		//fmt.Printf("%s = %v (%s)\n", path, rv.Interface(), rv.Type().String())
	}

	return nil
}

func (k *Knob) assignValue(rv reflect.Value, element *KnobElement, tagValue string) error {
	strValue, err := k.readValues(element, tagValue)
	if err != nil {
		return err
	}

	// assign types
	switch rv.Type() {
	case reflect.TypeFor[time.Duration]():
		duration, err := time.ParseDuration(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid duration str: %s", element.path, err)
		}

		rv.Set(reflect.ValueOf(duration))
		return nil
	}

	// assign base values
	switch rv.Kind() {
	case reflect.String:
		rv.SetString(strValue)
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		atoi, err := strconv.Atoi(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid int str: %s", element.path, err)
		}
		rv.SetInt(int64(atoi))
	case reflect.Bool:
		parsedBool, err := strconv.ParseBool(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid bool str: %s", element.path, err)
		}
		rv.SetBool(parsedBool)
	case reflect.Float32, reflect.Float64:
		float, err := strconv.ParseFloat(strValue, 64)
		if err != nil {
			return fmt.Errorf("%s = invalid float str: %s", element.path, err)
		}
		rv.SetFloat(float)
	default:
		return fmt.Errorf("%s = unsupported type: %s", element.path, rv.Type())
	}

	return nil
}

func (k *Knob) readValues(element *KnobElement, tagValue string) (string, error) {
	// todo potentially look at file

	prefixedEnv := k.prefixer(element.Env)
	strValue, ok := os.LookupEnv(prefixedEnv)
	if !ok {
		if element.Required {
			return "", fmt.Errorf("env is required, use %s to set value", prefixedEnv)
		}

		if element.Default == "" {
			return "", fmt.Errorf("value has no defaults, any non-required value must have defaults, add 'default:some_default' to your struct tag %s", tagValue)
		}

		strValue = element.Default
	}

	return strValue, nil
}

type KnobElement struct {
	Default  string
	Env      string
	Required bool
	Help     string
	Secret   bool

	path string
}

func (k *Knob) parseTag(tagValue string, ke *KnobElement) error {
	keyMap := make(map[string]string)
	err := k.loadKeymap(tagValue, keyMap)
	if err != nil {
		return err
	}

	for k, v := range keyMap {
		switch k {
		case "default":
			ke.Default = v
		case "env":
			ke.Env = v
		case "help":
			ke.Help = v
		case "required":
			parseBool, _ := strconv.ParseBool(v)
			ke.Required = parseBool
		case "secret":
			parseBool, _ := strconv.ParseBool(v)
			ke.Secret = parseBool
		default:
			fmt.Println("unsupported key", k)
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
