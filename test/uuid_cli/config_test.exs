defmodule UuidCli.ConfigTest do
  use ExUnit.Case

  alias UuidCli.Config

  test "Create config from parsed result - all set" do
    # Arrange
    parsed_result = %Optimus.ParseResult{
      args: %{},
      flags: %{random_case: true, replace_ambiguous: true, verbose: true},
      options: %{chars: 6},
      unknown: []
    }

    # Act
    config = Config.from_parsed(parsed_result)

    # Assert
    assert %Config{
             random_case: true,
             replace_ambiguous: true,
             verbose: true,
             chars: 6
           } = config
  end

  test "Create config from parsed result - not set" do
    # Arrange
    parsed_result = %Optimus.ParseResult{
      args: %{},
      flags: %{random_case: false, replace_ambiguous: false, verbose: false},
      options: %{chars: 0},
      unknown: []
    }

    # Act
    config = Config.from_parsed(parsed_result)

    # Assert
    assert %Config{
             random_case: false,
             replace_ambiguous: false,
             verbose: false,
             chars: 0
           } = config
  end
end
