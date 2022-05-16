defmodule RowMultip do
  def pmultiply(matrix_a, matrix_b) do
     new_b = MatrixMultiplication.transpose(matrix_b)

     PHOF.pmap(matrix_a, fn(row) ->
       Task.async(fn -> Enum.map(new_b, &dot_product(row, &1)) end)
        |> Task.await
     end)
     |> IO.inspect(charlists: :as_lists)
   end

   defp dot_product(row, column) do
     dp(row, column, 0)
   end
   defp dp([], [], acc), do: acc
   defp dp([hr|tr], [hc|tc], a) do
     dp(tr, tc, a + hr*hc)
   end
end

defmodule ColumnMultip do
  #Homework
end

defmodule MatrixMultiplication do
  def mult(m1, m2) do
    Enum.map m1, fn (x) -> Enum.map transpose(m2), fn (y) -> Enum.zip(x, y)
        |> Enum.map(fn {x, y} -> x * y end)
        |> Enum.sum
      end
    end
  end

  def transpose(m) do
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end
end

defmodule PMatrixMultiplication do
  import PHOF
  def mult(m1, m2) do
    PHOF.pmap m1, fn (x) -> PHOF.pmap transpose(m2), fn (y) -> Enum.zip(x, y)
        |> Enum.map(fn {x, y} -> x * y end)
        |> Enum.sum
      end
    end
  end

  def transpose(m) do
    List.zip(m) |> Enum.map(&Tuple.to_list(&1))
  end
end
