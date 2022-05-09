defmodule Pooly.Server do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct sup: nil, worker_sup: nil, size: nil, workers: nil, mfa: nil, monitors: nil
  end

  #API
  def start_link(sup, pool_config) do
    GenServer.start_link(__MODULE__,  [sup, pool_config], name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  def checkout do
    GenServer.call(__MODULE__, :checkout)
  end

  def checkin(worker_pid) do
    GenServer.cast(__MODULE__, {:checkin, worker_pid})
  end

  #Callbacks
  def init([sup, pool_config]) when is_pid(sup) do
    #2
    init(pool_config, %State{sup: sup})
    #3
    Process.flag(:trap_exit, true)
    monitors = :ets.new(:monitors, [:private])
    init(pool_config, %State{sup: sup, monitors: monitors})
  end
  def init([{:mfa, mfa}|rest], state) do
    init(rest, %{state | mfa: mfa})
  end
  def init([{:size, size}|rest], state) do
    init(rest, %{state | size: size})
  end
  def init([_|rest], state) do
    init(rest, state)
  end
  def init([], state) do
    send(self, :start_worker_supervisor)
    {:ok, state}
  end
  def init([sup, pool_config]) when is_pid(sup) do
    monitors = :ets.new(:monitors, [:private])
    init(pool_config, %State{sup: sup, monitors: monitors})
  end

  def handle_call(:checkout, {from_pid, _ref}, %{workers: workers, monitors: monitors} = state) do
    case workers do
      [worker|rest] ->
        ref = Process.monitor(from_pid)
        true = :ets.insert(monitors, {worker, ref})
        {:reply, worker, %{state | workers: rest}}
      [] ->
        {:reply, :noproc, state}
    end
  end

  def handle_call(:status, _from, %{workers: workers, monitors: monitors} = state) do
    {:reply, {length(workers), :ets.info(monitors, :size)}, state}
  end

  def handle_cast({:checkin, worker}, %{workers: workers, monitors: monitors} = state) do
    case :ets.lookup(monitors, worker) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(monitors, pid)
        {:noreply, %{state | workers: [pid|workers]}}
      [] ->
        {:noreply, state}
    end
  end

  #2
  def handle_info(:start_worker_supervisor, state = %{sup: sup, mfa: mfa, size: size}) do
    {:ok, worker_sup} = Supervisor.start_child(sup, supervisor_spec(mfa))
    workers = prepopulate(size, worker_sup)
    {:noreply, %{state | worker_sup: worker_sup, workers: workers}}
  end

  #3
  def handle_info({:DOWN, ref, _, _, _}, state = %{monitors: monitors, workers: workers}) do
    case :ets.match(monitors, {:"$1", ref}) do
      [[pid]] -> true = :ets.delete(monitors, pid)
                 new_state = %{state | workers: [pid | workers]}
                 {:noreply, new_state}
      [[]] -> {:noreply, state}
    end
  end

  #3
  def handle_info({:EXIT, pid, _reason}, state = %{monitors: monitors, workers: workers, worker_sup: worker_sup}) do
    case :ets.lookup(monitors, pid) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(monitors, pid)
        new_state = %{state | workers: [new_worker(worker_sup)|workers]}
        {:noreply, new_state}
      [[]] ->
        {:noreply, state}
    end
  end

  #Helpers
  defp supervisor_spec(mfa) do
    opts = [id: :"#{pool_config[:name]}Supervisor", restart: :temporary]
    supervisor(Pooly.WorkerSupervisor, [mfa], opts)
  end

  defp prepopulate(size, sup) do
    prepopulate(size, sup, [])
  end
  defp prepopulate(size, _sup, workers) when size < 1 do
    workers
  end
  defp prepopulate(size, sup, workers) do
    prepopulate(size - 1, sup, [new_worker(sup) | workers])
  end

  defp new_worker(sup) do
    {:ok, worker} = Supervisor.start_child(sup, [[]])
    worker
  end
end
