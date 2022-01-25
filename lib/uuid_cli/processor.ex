defmodule UuidCli.Processor do
  @moduledoc """
  Processes the incomfing config and outputs an expected UUID.
  """

  alias UuidCli.Config

  # ===== GENERATE =====

  @spec generate(UuidCli.Config.t()) :: bitstring()
  def generate(_config) do
    UUID.uuid4()
  end

  # ===== RANDOM CASE =====

  @spec random_case(bitstring(), UuidCli.Config.t()) :: bitstring()
  def random_case(uuid, %Config{random_case: true}) do
    uuid =
      uuid
      |> String.splitter("")
      |> Enum.map(&random_case_char/1)
      |> Enum.join()

    uuid
  end

  def random_case(uuid, _config), do: uuid

  # ===== CUT =====

  @spec cut(bitstring(), UuidCli.Config.t()) :: bitstring()
  def cut(uuid, %Config{chars: chars}) do
    uuid =
      if chars > 0 do
        uuid |> String.splitter("") |> Enum.take(chars + 1)
      else
        uuid
      end

    uuid
  end

  # ===== ===== PRIVATE ===== =====

  defp random_case_char(char) when is_bitstring(char) do
    if :rand.uniform() < 0.5 do
      String.upcase(char)
    else
      char
    end
  end

  defp random_case_char(char) do
    char
  end
end
