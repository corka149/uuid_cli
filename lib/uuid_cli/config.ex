defmodule UuidCli.Config do
  @moduledoc """
  Holds the whole configration of the CLI.
  """

  defstruct chars: 0, verbose: false, random_case: false

  alias UuidCli.Config

  @doc """
  Creates a config from the parse result.
  """
  @spec from_parsed(Optimus.ParseResult.t()) :: %UuidCli.Config{
          chars: any,
          random_case: any,
          verbose: any
        }
  def from_parsed(%Optimus.ParseResult{
        args: %{},
        flags: %{random_case: random_case, verbose: verbose},
        options: %{chars: chars},
        unknown: []
      }) do
    %Config{
      chars: chars,
      verbose: verbose,
      random_case: random_case
    }
  end
end
