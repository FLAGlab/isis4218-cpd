defmodule Agents do
    @session :session
    @sessions :sessions
    def start_link do
        Agent.start_link(fn -> 0 end, name: @session)
        Agent.start_link(fn -> %{} end, name: @sessions)
    end
    def new_session do
        Agent.update(@session, fn val -> val + 1 end)
        s = Agent.get(@session, fn val -> val end)
        Agent.update(@sessions, fn ss -> Map.update(ss, s, s, fn _ -> s end) end, fn -> s end)
    end

    defp get_sessions do
        Agent.get(@sessions, &Map.values(&1))
    end

end