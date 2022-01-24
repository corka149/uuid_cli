defmodule UuidCli do
  def main(argv) do
    Optimus.new!(
      name: "uuid",
      description: "Creates UUIDs with different combinations.",
      version: "0.0.1",
      author: "Sebastian Z. corka149@mailbox.org",
      allow_unknown_args: false,
      flags: [
        random_case: [
          short: "-r",
          long: "--random-case",
          help: "Use random case for characters in UUID",
          multiple: false
        ],
        verbose: [
          short: "-v",
          long: "--verbose",
          help: "Activates verbose mode",
          multiple: false
        ]
      ],
      options: [
        chars: [
          value_name: "CHARS",
          short: "-c",
          long: "--chars",
          help: "Amount of characters",
          parser: fn n ->
            case Integer.parse(n) do
              :error -> {:error, "Must be integer"}
              {chars, ""} -> {:ok, chars}
            end
          end,
          default: -1
        ]
      ]
    )
    |> Optimus.parse!(argv)
    |> debug()
    |> generate()
    |> cut()
    |> IO.puts()
  end

  # ===== ===== CMD ===== =====

  defp debug(
         %Optimus.ParseResult{
           flags: %{verbose: verbose}
         } = parse_result
       ) do
    if verbose do
      IO.inspect(parse_result)
    end

    parse_result
  end

  defp generate(
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

  defp generate(
         %Optimus.ParseResult{
           flags: %{random_case: false}
         } = parse_result
       ) do
    {UUID.uuid4(), parse_result}
  end

  defp cut(
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
