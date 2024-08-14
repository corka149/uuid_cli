package main

import (
	"fmt"
	"github.com/corka149/uuid_cli/generator"
	"github.com/spf13/cobra"
	"math/rand"
	"os"
	"time"
)

func main() {

	config := generator.UuidConfig{}

	rootCmd := cobra.Command{
		Use:   "uuid",
		Short: "Creates UUIDs with different combinations",
		Long:  "A quick and easy way to generate UUIDs for different cases.",
		Run: func(cmd *cobra.Command, args []string) {
			unixNano := time.Now().UnixNano()
			source := rand.NewSource(unixNano)
			r := rand.New(source)
			u, err := generator.GenUuid(config, r)

			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			fmt.Println(u)
		},
	}

	rootCmd.PersistentFlags().BoolVarP(&config.RandomCase, "random-case", "r", false, "Use random case for characters in UUID")
	rootCmd.PersistentFlags().BoolVarP(&config.ReplaceAmbiguous, "replace-ambiguous", "a", false, "Replace ambiguous 0 by Q")
	rootCmd.PersistentFlags().IntVarP(&config.Chars, "chars", "c", -1, "Amount of characters")

	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
