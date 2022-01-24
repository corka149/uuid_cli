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
      ]
    )
    |> Optimus.parse!(argv)
    |> debug()
    |> generate()
    |> IO.puts()
  end

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

  defp generate(%Optimus.ParseResult{
         args: %{},
         flags: %{random_case: true},
         options: %{}
       }) do
    UUID.uuid4()
    |> String.splitter("")
    |> Enum.map(&random_case/1)
  end

  defp generate(%Optimus.ParseResult{
         args: %{},
         flags: %{random_case: false},
         options: %{}
       }) do
    UUID.uuid4()
  end

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
