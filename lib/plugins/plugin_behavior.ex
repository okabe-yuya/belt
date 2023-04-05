defmodule Plugins.PluginBehavior do
  @callback start_link :: {:ok, term} | {:error, term}
  @callback receive_message(args :: term) :: {:ok, term} | {:error, term}
end
