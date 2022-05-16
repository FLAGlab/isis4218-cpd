defmodule InputReader do
  require Mapper

  def reader(file, partition) do
    case File.read(file) do
      {:ok, body} -> Enum.each(Regex.split(~r/\r|\n|\r\n/, String.trim(body)),
                    fn line -> spawn(fn -> Mapper.map(line, partition) end) end)
      {:error, reason} -> IO.puts :stderr, "File Error: #{reason}"
    end
  end
end
