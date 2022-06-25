defmodule IpMonitor.Utils do
  @moduledoc """
  Helper functions.
  """

  @doc """
  Helper fucntion used to parse the `settings.yml` file.
  """
  def parse_settings() do
    file = Path.join [File.cwd!, "config", "settings.yml"]
    {status, data} = YamlElixir.read_from_file file
    if status != :ok do
      raise "Cannot read the settings configuration file !"
    end
    # Convert 'monitor.every' to milliseconds
    put_in data, ["monitor", "every"], parse_every(data["monitor"]["every"])
  end

  # -----

  defp parse_every(every) do
    try do
      cond do
        String.contains? every, "mn" ->
          every
          |> String.replace("mn", "")
          |> String.trim()
          |> String.to_integer()
          |> Kernel.*(1000 * 60)           # Convert to milliseconds
        String.contains? every, "h" ->
          every
          |> String.replace("h", "")
          |> String.trim()
          |> String.to_integer()
          |> Kernel.*(1000 * 60 * 60)      # Convert to milliseconds
        true ->
          raise "Cannot parse monitor.every setting"
      end
    rescue
      _ -> raise "Cannot parse monitor.every setting"
    end
  end
end
