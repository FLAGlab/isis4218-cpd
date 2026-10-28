defmodule ParallelNQueens do
  @doc """
  Solves the N-Queens problem in parallel for board size `n`.
  Returns the total count of valid board configurations.
  """
  def solve(n) when is_integer(n) and n > 0 do
    # Spawn a parallel task for each possible queen position in row 1
    0..(n - 1)
    |> Task.async_stream(
      fn col -> solve_branch([col], 1, n) end,
      max_concurrency: System.schedulers_online(),
      ordered: false
    )
    |> Enum.reduce(0, fn {:ok, count}, acc -> acc + count end)
  end

  # Base case: Board fully populated with non-attacking queens
  defp solve_branch(queens, row, n) when row == n, do: 1

  # Recursive branch evaluation
  defp solve_branch(queens, row, n) do
    0..(n - 1)
    |> Enum.reduce(0, fn col, acc ->
      if valid?(queens, row, col) do
        acc + solve_branch([col | queens], row + 1, n)
      else
        acc
      end
    end)
  end

  # Safe placement check across vertical columns and diagonals
  defp valid?(queens, current_row, current_col) do
    queens
    |> Enum.with_index()
    |> Enum.all?(fn {q_col, idx} ->
      q_row = current_row - 1 - idx
      q_col != current_col and abs(q_col - current_col) != abs(q_row - current_row)
    end)
  end
end

# Benchmarking execution for N = 12
#{time_us, result} = :timer.tc(fn -> ParallelNQueens.solve(12) end)
#IO.puts("Found #{result} solutions in #{time_us / 1000} ms.")
