defmodule Supervisor do
  def start, do: spawn(__MODULE__, :loop_system, [])

  def loop_system do
    Process.flag(:trap_exit, true)
    loop()
  end

  def loop() do
      pid = Cache.start_link
      receive do
        {:EXIT, ^pid, :normal} -> IO.puts "Cache exited normally"
                                  :ok
        {:EXIT, ^pid, reason} -> IO.puts "Cache #{inspect self()} exited with reason #{inspect reason} - Restarting it"
                                 loop()
      end
  end
end

defmodule Cache do
  def start_link do
    pid = spawn_link(__MODULE__, :loop, [Map.new, 0])
    Process.register(pid, :cache)
    pid
  end

  def put(url, page), do: send :cache, {:put, url, page}

  def get(url) do
    ref = make_ref()
    send :cache, {:get, self(), ref, url}
    receive do
      {:ok, ^ref, page} -> page
    end
  end

  def size do
    ref = make_ref()
    send :cache, {:size, self(), ref}
    receive do
      {:ok, ^ref, s} -> s
    end
  end

  def terminate, do: send :cache, {:terminate}
  def kill, do: send :cache, {:kill, :cache_failure}

  def loop(pages, size) do
    receive do
      {:put, url, page} ->
        new_pages = Map.put(pages, url, page)
        new_size = size + byte_size(page)
        loop(new_pages, new_size)
      {:get, sender, ref, url} ->
        send sender, {:ok, ref, pages[url]}
        loop(pages, size)
      {:size, sender, ref} ->
        send sender, {:ok, ref, size}
        loop(pages, size)
      {:terminate} -> exit(:normal)
      {:kill, reason} -> exit(reason)
    end
  end
end

defmodule Test do
  def test do
    IO.puts Cache.size
    IO.puts Cache.put("Hello", "World")
    IO.puts Cache.size
    Cache.put "nothere", nil
    IO.puts Cache.size
    IO.puts Cache.put("Hello", "World")
    IO.puts Cache.get("Hello")
    Cache.get("World")
  end

  def test1 do
    Supervisor.start
    a1 = spawn(&Test.loop/0)
    a2 = spawn(&Test.loop/0)
    op1(a1, "a", "b")
    op1(a1, "a", nil)
    op2(a2, "a")
  end

  def op1(actor, web, page) do
    send actor, {:op1, web, page}
  end

  def op2(actor, web) do
    send actor, {:op2, web}
  end

  def loop() do
    receive do
    {:op1, web, page} ->
      Cache.put(web, page)
    {:op2, web} ->
      Cache.get(web)
    end
    loop()
  end
end

defmodule Cache2 do
  def start_link do
    pid = spawn(__MODULE__, :loop, [Map.new, 0])
    Process.register(pid, :cache2)
    pid
  end

  def put(url, page), do: send :cache2, {:put, url, page}

  def get(url) do
    ref = make_ref()
    send :cache2, {:get, self(), ref, url}
    receive do
      {:ok, ^ref, page} -> page
    after 1000 -> IO.puts "gave up"
    end
  end

  def size do
    ref = make_ref()
    send :cache2, {:size, self(), ref}
    receive do
      {:ok, ^ref, s} -> s
    end
  end

  def terminate, do: send :cache2, {:terminate}

  def loop(pages, size) do
    receive do
      {:put, url, page} ->
        IO.puts "putting"
        new_pages = Map.put(pages, url, page)
        new_size = size + byte_size(page)
        loop(new_pages, new_size)
      {:get, sender, ref, url} ->
        IO.puts "getting"
        :timer.sleep(5000)
        send sender, {:ok, ref, pages[url]}
        loop(pages, size)
      {:size, sender, ref} ->
        send sender, {:ok, ref, size}
        loop(pages, size)
      {:terminate} -> exit(:normal)
    end
  end
end
