defmodule DirSize do

  def size(path, :files) do
    seq_size(path)
  end
  def size(path, :dir) do
    all = Path.wildcard(path <> "/*")
    IO.inspect all
    files = Enum.filter(all, fn f -> length(String.split(f, ".")) > 1 end)
    dirs = Enum.filter(all, fn f -> length(String.split(f, ".")) == 1 end)
    td = Enum.map(dirs, fn d -> Task.async(fn -> size(d, :dir) end) end)
    tf = Enum.map(files, fn f -> Task.async(fn -> size(f, :files) end) end)
    sum_d = List.foldl(td, 0, fn t, ac -> Task.await(t) + ac end)
    sum_f = List.foldl(tf, 0, fn t, ac -> Task.await(t) + ac end)
    sum_d + sum_f
  end

  def seq_size(file) do
    {:ok, fs} = File.stat(file)
    Map.get(fs, :size)
  end
end
