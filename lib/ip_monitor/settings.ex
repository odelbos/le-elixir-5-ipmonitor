defmodule IpMonitor.Settings do
  @moduledoc """
  Store the global settings.
  """
  require Logger
  use Agent

  def start_link(settings) do
    Logger.info "Start settings agent"
    Agent.start_link(fn -> settings end, name: __MODULE__)
  end

  @doc """
  Get all the settings.
  """
  def all do
    Agent.get IpMonitor.Settings, fn s -> s end
  end

  @doc """
  Get specific settings given his key.
  """
  def get(key) do
    Agent.get IpMonitor.Settings, fn s -> s[key] end
  end

  @doc """
  Get monitor settings.
  """
  def get_monitor() do
    Agent.get __MODULE__, & &1["monitor"]
  end

  @doc """
  Get getip service settings.
  """
  def get_service_getip() do
    Agent.get __MODULE__, & &1["services"]["getip"]
  end

  @doc """
  Get pushover service settings.
  """
  def get_service_pushover() do
    Agent.get __MODULE__, & &1["services"]["pushover"]
  end

  @doc """
  Get tasks settings.
  """
  def get_tasks() do
    Agent.get IpMonitor.Settings, & &1["tasks"]
  end
end
