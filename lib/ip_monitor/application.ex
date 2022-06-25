defmodule IpMonitor.Application do
  @moduledoc false

  use Application
  alias IpMonitor.Utils

  @impl true
  def start(_type, _args) do
    settings = Utils.parse_settings()
    children = [
      {IpMonitor.Settings, settings}
    ]
    opts = [strategy: :one_for_one, name: IpMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
