defmodule Pooly do
  use Application

  def start(_type, _args) do
    #2
    pool_config = [mfa: {SampleWorker, :start_link, []}, size: 5]
    start_pool(pool_config)
  end

  def start_pool(pool_config) do
    #1
    #Pooly.WorkerSupervisor.start_link({SampleWorker, :start_link, []})
    #2
    Pooly.Supervisor.start_link(pool_config)
  end

  def checkout do
    Pooly.Server.checkout
  end

  def checkin(worker_pid) do
    Pooly.Server.checkin(worker_pid)
  end
  def status do
    Pooly.Server.status
  end
end
