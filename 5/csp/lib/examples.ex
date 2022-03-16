defmodule CSPE do
    use CSP

    def p2p do
        channel = Channel.new
        a = spawn_link(fn -> Channel.put(channel, 42) end)
        b = spawn_link(fn -> Channel.get(channel) |> IO.puts end)
    end

    def cross_send do
        c = Channel.new
        d = Channel.new
        a = spawn_link(fn -> Channel.put(c, 1) end)
        b = spawn_link(fn -> Channel.put(d, 1) end) 
    end

    def blocking do
        c = Channel.new
        d = Channel.new
        a = spawn_link(fn -> Channel.get(c) end)
        b = spawn_link(fn -> Channel.get(d) end) 
    end

    def client_server do
        c = Channel.new
        d = Channel.new
        client = spawn_link(fn -> 
            Channel.put(c, 1) 
            Channel.get(d) end)
        server = spawn_link(fn -> 
            Channel.get(c)
            Channel.put(d, 1) end)
    end
end