defmodule MapReduce do
  require InputReader
  require Partition
  @moduledoc """
  Documentation for MapReduce.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MapReduce.hello()
      :world

  """
  def main(args) do
    args |> parse_args() |> pipeline()
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [file: :string])
    options
  end

  defp pipeline([]), do: IO.puts "No file given"
  defp pipeline(options) do
    partition = elem(Partition.start_link, 1)
    InputReader.reader("#{options[:file]}", partition)
    forever()
  end

  defp forever(), do: forever()
end
