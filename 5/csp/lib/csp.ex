defmodule MyCSP do
  use CSP

  def hello do
    channel = Channel.new
    pid = spawn_link(fn ->
        Channel.put(channel, :hello)
        Channel.put(channel, :cruel)
        Channel.put(channel, :world) end)
    :timer.sleep(5000)
    IO.puts Process.alive?(pid)
    IO.puts Channel.get(channel)
    IO.puts Channel.get(channel)
    channel
  end

  def channel_size do
    channel = Channel.new(buffer_size: 10)
    chan = Channel.new
    for x <- chan, into: channel do
      x*2
    end
    Channel.close(chan)
  end

  def sum do
    o = Channel.new(buffer_size: 10)
    Enum.each(1..10, fn j ->
        do_sum(j, o)
      end)
    for _ <- 1..Channel.size(o), do: Channel.get(o)
  end

  defp do_sum(val, o) do
    i = Enum.into(1..val, Channel.new(buffer_size: val))
    Channel.close(i)
    sum = Channel.wrap(i)
          |> Enum.reduce(fn(x, acc) -> x + acc end)
    spawn_link(fn -> Channel.put(o, sum) end)
  end

  def comp do
    channel = Enum.into(1..10, Channel.new)
    :ok = Channel.close(channel)
    other_channel = for x <- channel, into: Channel.new(buffer_size: 10) do
      x * 2
    end
    :ok = Channel.close(other_channel)
    Enum.to_list(other_channel)
  end
end
