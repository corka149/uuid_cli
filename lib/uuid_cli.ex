defmodule UuidCli do
  @moduledoc """
  CLI Main
  """

  alias UuidCli.Processor

  def main(argv) do
    UuidCli.Interface.uuid_cli()
    |> Optimus.parse!(argv)
    |> run()
    |> IO.puts()
  end

  defp run(parse_result) do
    parse_result
    |> Processor.debug()
    |> Processor.generate()
    |> Processor.cut()
  end
end
