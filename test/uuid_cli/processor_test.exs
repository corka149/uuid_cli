defmodule UuidCli.ProcessorTest do
  use ExUnit.Case

  alias UuidCli.Processor
  alias UuidCli.Config

  test "Cut uuid to length 4" do
    # Arrange
    uuid = UUID.uuid4()
    config = %Config{chars: 4}

    # Act
    uuid = Processor.cut(uuid, config)

    # Assert
    assert String.length(uuid) == 4
  end

  test "No cut of uuid when no limit is provided" do
    # Arrange
    orig_uuid = UUID.uuid4()
    config = %Config{}

    # Act
    uuid = Processor.cut(orig_uuid, config)

    # Assert
    assert String.length(uuid) == String.length(orig_uuid)
  end

  test "Random case a uuid when enabled" do
    # Arrange
    uuid = UUID.uuid4()
    config = %Config{random_case: true}

    # Act - because it is random
    many_uuids =
      0..100
      |> Enum.map(fn _ -> Processor.random_case(uuid, config) end)
      |> Enum.join()

    # Assert
    assert many_uuids
           |> String.splitter("")
           |> Enum.any?(fn char -> String.match?(char, ~r/[A-Z]/) end)
  end

  test "Do not random case a uuid when not enabled" do
    # Arrange
    uuid = UUID.uuid4()
    config = %Config{random_case: false}

    # Act - because it is random
    many_uuids =
      0..100
      |> Enum.map(fn _ -> Processor.random_case(uuid, config) end)
      |> Enum.join()

    # Assert
    assert not (many_uuids
                |> String.splitter("")
                |> Enum.any?(fn char -> String.match?(char, ~r/[A-Z]/) end))
  end

  test "Replace ambiguous characters" do
    # Arrange
    uuid = "7ad05ff7-9f56-46c6-81a2-4b203fbf7fbO"
    config = %Config{replace_ambiguous: true}

    # Act
    uuid = Processor.replace_ambiguous(uuid, config)

    # Assert
    assert not String.contains?(uuid, ["0", "O"])
  end

  test "Do not replace ambiguous characters when option not set" do
    # Arrange
    uuid = "7ad05ff7-9f56-46c6-81a2-4b203fbf7fbO"
    config = %Config{replace_ambiguous: false}

    # Act
    uuid = Processor.replace_ambiguous(uuid, config)

    # Assert
    assert String.contains?(uuid, ["0", "O"])
  end
end
