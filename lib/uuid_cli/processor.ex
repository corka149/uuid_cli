defmodule UuidCli.Processor do
  @moduledoc """
  Processes the incomfing config and outputs an expected UUID.
  """

  alias UuidCli.Config

  # ===== GENERATE =====

  @doc """
  Generate a UUID.
  """
  @spec generate(UuidCli.Config.t()) :: bitstring()
  def generate(_config) do
    UUID.uuid4()
  end

  # ===== RANDOM CASE =====

  @doc """
  Switch randomly case if configured.
  """
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

  @doc """
  Cut off characters to match the expected length.
  """
  @spec cut(bitstring(), UuidCli.Config.t()) :: bitstring()
  def cut(uuid, %Config{chars: chars}) do
    uuid =
      if chars > 0 do
        uuid |> String.split_at(chars) |> elem(0)
      else
        uuid
      end

    uuid
  end

  # ===== REPLACE AMBIGUOUS ======

  @spec replace_ambiguous(bitstring(), UuidCli.Config.t()) :: bitstring()
  def replace_ambiguous(uuid, %Config{replace_ambiguous: true}) do
    uuid
    |> String.replace("O", "Q")
    |> String.replace("0", "Q")
  end

  def replace_ambiguous(uuid, _config), do: uuid

  # ===== ===== PRIVATE ===== =====

  defp random_case_char(char) do
    if :rand.uniform() < 0.5 do
      String.upcase(char)
    else
      char
    end
  end
end
