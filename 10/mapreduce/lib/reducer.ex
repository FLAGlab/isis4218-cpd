defmodule Reducer do
  def reduce(tuples, out_writer) do
    send(out_writer, {:process_put, self()})
    case tuples do
      [] -> IO.puts :stderr, "Empty List"
      tuples -> send(out_writer,
                {:value_put, "#{elem(hd(tuples), 0)}
                              #{Enum.reduce(tuples, 0, fn ({_, v}, total) -> v + total end)}"})
    end
  end
end
