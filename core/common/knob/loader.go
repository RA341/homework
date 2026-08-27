package knob

import (
	"fmt"
	"os"
	"reflect"
	"strconv"
	"time"
)

type Loader struct {
	Prefixer Prefixer
}

func (k *Loader) assignValue(rv reflect.Value, element *Element, tagValue string) error {
	strValue, err := k.readValues(element, tagValue)
	if err != nil {
		return err
	}

	// assign types
	switch rv.Type() {
	case reflect.TypeFor[time.Duration]():
		duration, err := time.ParseDuration(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid duration str: %s", element.Path, err)
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
			return fmt.Errorf("%s = invalid int str: %s", element.Path, err)
		}
		rv.SetInt(int64(atoi))
	case reflect.Bool:
		parsedBool, err := strconv.ParseBool(strValue)
		if err != nil {
			return fmt.Errorf("%s = invalid bool str: %s", element.Path, err)
		}
		rv.SetBool(parsedBool)
	case reflect.Float32, reflect.Float64:
		float, err := strconv.ParseFloat(strValue, 64)
		if err != nil {
			return fmt.Errorf("%s = invalid float str: %s", element.Path, err)
		}
		rv.SetFloat(float)
	default:
		return fmt.Errorf("%s = unsupported type: %s", element.Path, rv.Type())
	}

	return nil
}

func (k *Loader) readValues(element *Element, tagValue string) (string, error) {
	// todo potentially look at file

	prefixedEnv := k.Prefixer(element.Env)
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
