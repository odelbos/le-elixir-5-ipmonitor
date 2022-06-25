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
    {url, _every} = get_settings()

    opts = [timeout: 5000, recv_timeout: 5000, follow_redirect: false]
    response = HTTPoison.get url, [], opts
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        case compare_ip body, state do
          {:change, new_state} ->
            Logger.info "Got IP : #{body} - (change)"
            {:noreply, new_state}
          {:set, new_state} ->
            Logger.info "Got IP : #{body} - (set state)"
            {:noreply, new_state}
          _ ->
            Logger.info "Got IP : #{body} - (no change)"
            {:noreply, state}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warn "Error, #{reason}"
        {:noreply, state}
      _ ->
        Logger.warn "Unknown error"
        {:noreply, state}
    end
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

  defp compare_ip(ip, %{ip: old_ip} = _state) when old_ip == "" do
    {:set, %{ip: ip}}
  end

  defp compare_ip(ip, %{ip: old_ip} = state) when ip == old_ip do
    {:no_change, state}
  end

  defp compare_ip(ip, %{ip: _old_ip} = _state) do
    {:change, %{ip: ip}}
  end
end
