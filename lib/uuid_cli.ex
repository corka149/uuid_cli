defmodule UuidCli do
  @moduledoc """
  CLI Main
  """

  alias UuidCli.Processor
  alias UuidCli.Config

  def main(argv) do
    UuidCli.Interface.uuid_cli()
    |> Optimus.parse!(argv)
    |> run()
    |> output()
  end

  # ===== ===== PRIVATE ===== =====

  # Do the work
  defp run(parse_result) do
    config =
      parse_result
      |> Config.debug()
      |> Config.from_parsed()

    Processor.generate(config)
    |> Processor.random_case(config)
    |> Processor.cut(config)
  end

  # Output the work
  defp output(uuid) do
    IO.puts(uuid)
  end
end
