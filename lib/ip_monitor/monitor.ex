defmodule IpMonitor.Monitor do
  require Logger
  use GenServer

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: :ip_monitor
  end

  @impl true
  def init(state) do
    {url, every} = get_settings()
    Logger.info "Init Monitor, check every: #{every} ms"
    Logger.info "Service: #{url}"
    :timer.send_after 200, :get_ip
    schedule every
    {:ok, state}
  end

  @impl true
  def handle_info(:get_ip, state) do
    {url, every} = get_settings()

    Logger.info "service url: #{url}"
    Logger.info "every: #{every} ms"

    {:noreply, state}
  end

  # -----

  defp get_settings() do
    %{"url" => url} = IpMonitor.Settings.get_service_getip()
    %{"every" => every} = IpMonitor.Settings.get_monitor()
    {url, every}
  end

  defp schedule(every) do
    :timer.send_interval every, :get_ip
  end
end
