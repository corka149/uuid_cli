defmodule UuidCli.Interface do
  @moduledoc false

  @doc """
  Entry point description of CLI.
  """
  @spec uuid_cli :: Optimus.t()
  def uuid_cli do
    Optimus.new!(
      name: "uuid",
      description: "Creates UUIDs with different combinations.",
      version: "0.0.1",
      author: "Sebastian Z. corka149@mailbox.org",
      allow_unknown_args: false,
      flags: [
        random_case: random_case_flag(),
        verbose: verbose_flag(),
        replace_ambiguous: replace_ambiguous_chars_flag()
      ],
      options: [
        chars: chars_option()
      ]
    )
  end

  defp random_case_flag do
    [
      short: "-r",
      long: "--random-case",
      help: "Use random case for characters in UUID",
      multiple: false
    ]
  end

  defp verbose_flag do
    [
      short: "-v",
      long: "--verbose",
      help: "Activates verbose mode",
      multiple: false
    ]
  end

  defp replace_ambiguous_chars_flag do
    [
      short: "-a",
      long: "--replace-ambiguous",
      help: "Replace ambiguous chars O and 0 by Q",
      multiple: false
    ]
  end

  defp chars_option do
    [
      value_name: "CHARS",
      short: "-c",
      long: "--chars",
      help: "Amount of characters",
      parser: &postive_int_parser/1,
      default: 0
    ]
  end

  # ===== PARSER =====

  defp postive_int_parser(n) do
    case Integer.parse(n) do
      :error -> {:error, "Must be postive integer"}
      {chars, ""} when chars <= 0 -> {:error, "Must be postive integer"}
      {chars, ""} -> {:ok, chars}
    end
  end
end
