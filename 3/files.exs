defmodule WordLoader do
  def load_from_files(file_names) do
    file_names
      |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
      |> Enum.map(&Task.await/1)
  end

  defp load_file(name) do
    File.stream!(name, [], :line)
      |> Enum.map(&String.trim/1)
      |> PROCESS_THE_LINE
  end

  def main do
    load_from_files("FILE_NAME") 
  end
end
