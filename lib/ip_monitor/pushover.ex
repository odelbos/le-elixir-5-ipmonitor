defmodule IpMonitor.Pushover do
  require Logger
  use GenServer
  alias IpMonitor.Settings

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{}, name: :pushover)
  end

  def init(state) do
    {:ok, state}
  end

  # -----

  def push_new_ip(new_ip, old_ip) do
    GenServer.cast :pushover, {:push, new_ip, old_ip}
  end

  # -----

  def handle_cast({:push, new_ip, old_ip}, state) do
    settings = Settings.get_service_pushover()
    send_push new_ip, old_ip, settings
    {:noreply, state}
  end

  # -----

  defp send_push(new_ip, old_ip, %{"enable" => true} = settings) do
    %{"url" => url, "user" => user, "token" => token} = settings
    title = "Alert : Ip change"
    msg = "<b>Old IP:</b> #{old_ip}<br/><b>New IP:</b> #{new_ip}"
    params = %{
      user: user,
      token: token,
      title: title,
      html: 1,
      message: msg
    }
    payload = URI.encode_query params
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    _response = HTTPoison.post(url, payload, headers)
    Logger.info "Pushover: Alert sent"
  end

  defp send_push(_new_ip, _old_ip, _settings) do
    # Nothing to do, pushover is desabled
  end
end
