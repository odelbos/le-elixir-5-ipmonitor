defmodule IpMonitor.Tasks do
  require Logger
  use GenServer
  alias IpMonitor.Pushover

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: :tasks
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  # -----

  def run(task) do
    GenServer.cast :tasks, {:run, task}
  end

  # -----

  @impl true
  def handle_cast({:run, task}, state) do
    %{"name" => name, "cmd" => cmd, "params" => params} = task
    Logger.info "Tasks : run task #{name}"
    {_result, code} = System.cmd cmd, params
    if code != 0 do
      msg = "Command: #{name} failed"
      Logger.warn msg
      Pushover.push_error msg
    end
    {:noreply, state}
  end
end
