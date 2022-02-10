defmodule ServerSessions do
  @session :session
  @sessions :sessions

  def start_link do
    Agent.start_link(fn -> 0 end, name: @session)
    Agent.start_link(fn -> %{} end, name: @sessions)
  end

  def next_session do
    Agent.update(@session, fn session -> session + 1 end)
    Agent.get(@session, fn session -> session end)
  end

  def new_session(session) do
    ns = next_session
    Agent.update(@sessions, &Map.update(&1, ns, session, fn _ -> session end))
  end

  def get_session(session_id) do
    Agent.get(@sessions, &Map.get(&1, session_id))
  end
end



defmodule ExpiredSessions do
  @session :session
  @sessions :sessions

  def start_link do
    Agent.start_link(fn -> 0 end, name: @session)
    Agent.start_link(fn -> %{} end, name: @sessions)
  end

  def next_session do
    Agent.update(@session, fn session -> session + 1 end)
    Agent.get(@session, fn session -> session end)
  end

  def new_session(session) do
    ns = next_session
    s = %{ns => session, :last_used => :os.system_time(:millisecond)}
    Agent.update(@sessions, &Map.update(&1, ns, s, fn _ -> s end))
  end

  def get_session(session_id) do
    s = Agent.get_and_update(@sessions, fn map -> {
      Map.get(map, session_id)[session_id],
      Map.update(map, session_id, Map.update(Map.get(map, session_id),
                                            :last_used,
                                            :os.system_time(:millisecond),
                                            &(&1)))
    } end)
  end
end
