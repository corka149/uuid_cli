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

  defp run(parse_result) do
    parse_result
    |> Processor.debug()
    |> Config.from_parsed()
    |> Processor.generate()
    |> Processor.cut()
  end

  defp output({uuid, _config}) do
    IO.puts(uuid)
  end
end
