defmodule Test do
  alias ParallelNQueens
  alias SequentiaNQueens

  def main do
    # Board sizes to test
    sizes = 4..14

    IO.puts("N,Sequential_ms,Parallel_ms")

    Enum.each(sizes, fn n ->
      {time_seq, _} = :timer.tc(fn -> SequentialNQueens.solve(n) end)
      {time_par, _} = :timer.tc(fn -> ParallelNQueens.solve(n) end)

        seq_ms = time_seq / 1000.0
        par_ms = time_par / 1000.0

        IO.puts("#{n},#{seq_ms},#{par_ms}")
    end)
  end

  def main_s do
    # Board sizes to test
    sizes = 4..15

    IO.puts("N,Sequential_ms,Parallel_ms")

    Enum.each(sizes, fn n ->
      {time_seq, _} = :timer.tc(fn -> SequentialNQueens.solve(n) end)

        seq_ms = time_seq / 1000.0

        IO.puts("#{n},#{seq_ms} s")
    end)
  end

  def main_p do
    # Board sizes to test
    sizes = 4..15

    IO.puts("Parallel_ms")

    Enum.each(sizes, fn n ->
      {time_par, _} = :timer.tc(fn -> ParallelNQueens.solve(n) end)

        par_ms = time_par / 1000.0

        IO.puts("#{n},#{par_ms} s")
    end)
  end
end
