defmodule OutputWriter do
  def start_link do
    Task.start_link(fn -> loop([], []) end)
  end

  defp loop(processes, values) do
    mailbox_length = elem(Process.info(self(), :message_queue_len), 1)
    if (mailbox_length == 0), do: reducer_check(processes, values)
    receive do
      {:process_put, caller} -> loop([caller | processes], values)
      {:value_put, value} -> loop(processes, [value | values])
    end
  end

  defp reducer_check(processes, values) do
    check = Enum.filter(processes, fn process -> Process.alive?(process) end)
    if (length(check) == 0 && length(processes) != 0) do
      {:ok, file} = File.open(Path.join("test", "output.txt"), [:write])
      for value <- values do
        IO.puts value
        IO.write(file, value <> ~s(\n))
      end
      File.close(file)
      Process.exit(self(), :kill)
    end
  end
end
