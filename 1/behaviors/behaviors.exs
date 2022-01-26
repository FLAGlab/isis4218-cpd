defmodule Parser do
  @callback parse(String.t, Int.t) :: {:ok, term, term} | {:error, String.t}

  def parse!(implementation, contents) do
    case implementation.parse(contents) do
      {:ok, d1} -> IO.inspect("#{d1}")
      {:error, error} -> raise ArgumentError, "----- parse error #{error}"
      _ -> IO.puts "Something bad happened"
    end
  end
end


defmodule Test do
  @behaviour Parser

  @impl Parser
  def parse(num, int) do
    {:ok, "bad #{num}", "worse #{int}"}
  end
end
