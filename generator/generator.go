package generator

import (
	"github.com/google/uuid"
	"math/rand"
	"strings"
)

type UuidConfig struct {
	RandomCase       bool
	ReplaceAmbiguous bool
	Chars            int
}

func GenUuid(config UuidConfig, random *rand.Rand) (string, error) {
	uuid.SetRand(random)

	uuid4, err := uuid.NewRandom()

	if err != nil {
		return "", err
	}

	uuidStr := uuid4.String()

	if config.Chars > 0 {
		uuidStr = uuidStr[:config.Chars]
	}

	if config.ReplaceAmbiguous {
		uuidStr = strings.Replace(uuidStr, "0", "Q", -1)
	}

	if config.RandomCase {
		newUuidStr := ""
		split := strings.Split(uuidStr, "")

		for _, c := range split {
			if random.Intn(2) == 0 && c != "-" {
				newUuidStr += strings.ToUpper(c)
			} else {
				newUuidStr += c
			}
		}

		uuidStr = newUuidStr
	}

	return uuidStr, nil
}
