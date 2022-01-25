defmodule UuidCli.Processor do
  @moduledoc """
  Processes the incomfing config and outputs an expected UUID.
  """

  alias UuidCli.Config

  @spec debug(Optimus.ParseResult.t()) :: Optimus.ParseResult.t()
  def debug(
        %Optimus.ParseResult{
          flags: %{verbose: verbose}
        } = parse_result
      ) do
    if verbose do
      IO.inspect(parse_result)
    end

    parse_result
  end

  # ===== GENERATE =====

  def generate(%Config{random_case: true} = config) do
    uuid =
      UUID.uuid4()
      |> String.splitter("")
      |> Enum.map(&random_case/1)
      |> Enum.join()

    {uuid, config}
  end

  def generate(%Config{random_case: false} = config) do
    {UUID.uuid4(), config}
  end

  # ===== CUT =====

  def cut({uuid, %Config{chars: chars} = config}) do
    uuid =
      if chars > 0 do
        uuid |> String.splitter("") |> Enum.take(chars + 1)
      else
        uuid
      end

    {uuid, config}
  end

  # ===== ===== PRIVATE ===== =====

  defp random_case(char) when is_bitstring(char) do
    if :rand.uniform() < 0.5 do
      String.upcase(char)
    else
      char
    end
  end

  defp random_case(char) do
    char
  end
end
