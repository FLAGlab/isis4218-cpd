defmodule SequentialNQueens do
  @doc """
  Solves the N-Queens problem sequentially for board size `n`.
  Returns the total count of valid board configurations.
  """
  def solve(n) when is_integer(n) and n > 0 do
    place_queen([], 0, n)
  end

  # Base case: All N queens successfully placed
  defp place_queen(_queens, row, n) when row == n, do: 1

  # Iterate through each column in the current row
  defp place_queen(queens, row, n) do
    0..(n - 1)
    |> Enum.reduce(0, fn col, acc ->
      if valid?(queens, row, col) do
        acc + place_queen([col | queens], row + 1, n)
      else
        acc
      end
    end)
  end

  # Check if placing a queen at (current_row, current_col) conflicts with existing queens
  defp valid?(queens, current_row, current_col) do
    queens
    |> Enum.with_index()
    |> Enum.all?(fn {q_col, idx} ->
      q_row = current_row - 1 - idx
      q_col != current_col and abs(q_col - current_col) != abs(q_row - current_row)
    end)
  end
end

# Example execution
#{time_us, result} = :timer.tc(fn -> SequentialNQueens.solve(12) end)
#IO.puts("Found #{result} solutions sequentially in #{time_us / 1000} ms.")
