package generator_test

import (
	"github.com/corka149/uuid_cli/generator"
	"math/rand"
	"testing"
)
import "github.com/stretchr/testify/assert"

func TestGenUuidWithoutOptions(t *testing.T) {
	// Given
	r := random()
	conf := generator.UuidConfig{}

	// When
	uuid, err := generator.GenUuid(conf, r)

	// Then
	assert.Nil(t, err)
	assert.Equal(t, "52fdfc07-2182-454f-963f-5f0f9a621d72", uuid)
}

func TestGenUuidWith10Chars(t *testing.T) {
	// Given
	r := random()
	conf := generator.UuidConfig{Chars: 10}

	// When
	uuid, err := generator.GenUuid(conf, r)

	// Then
	assert.Nil(t, err)
	assert.Len(t, uuid, 10)
	assert.Equal(t, "52fdfc07-2", uuid)
}

func TestGenUuidWithReplaceAmbiguous(t *testing.T) {
	// Given
	r := random()
	conf := generator.UuidConfig{ReplaceAmbiguous: true}

	// When
	uuid, err := generator.GenUuid(conf, r)

	// Then
	assert.Nil(t, err)
	assert.NotContains(t, uuid, "0")
}

func TestGenUuidWithRandomCase(t *testing.T) {
	// Given
	r := random()
	conf := generator.UuidConfig{RandomCase: true}

	// When
	uuid, err := generator.GenUuid(conf, r)

	// Then
	assert.Nil(t, err)
	assert.Equal(t, "52FdFC07-2182-454f-963f-5F0f9a621d72", uuid)
}

func random() *rand.Rand {
	source := rand.NewSource(1)
	return rand.New(source)
}
