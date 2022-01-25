defmodule UuidCli.Processor do
  @moduledoc """
  Processes the incomfing config and outputs an expected UUID.
  """

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

  def generate(
        %Optimus.ParseResult{
          flags: %{random_case: true}
        } = parse_result
      ) do
    uuid =
      UUID.uuid4()
      |> String.splitter("")
      |> Enum.map(&random_case/1)
      |> Enum.join()

    {uuid, parse_result}
  end

  def generate(
        %Optimus.ParseResult{
          flags: %{random_case: false}
        } = parse_result
      ) do
    {UUID.uuid4(), parse_result}
  end

  def cut(
        {uuid,
         %Optimus.ParseResult{
           options: %{chars: chars}
         }}
      ) do
    if chars > 0 do
      uuid |> String.splitter("") |> Enum.take(chars + 1)
    else
      uuid
    end
  end

  # ===== ===== HELPER ===== =====

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
