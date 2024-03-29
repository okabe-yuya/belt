defmodule Plugins.Viewer do
  @behaviour Plugins.PluginBehavior

  def start_link do
    pid = spawn_link(__MODULE__, :receive_message, [1])
    {:ok, pid}
  end

  def receive_message(args) do
    receive do
      {:value, from, value} ->
        IO.puts(value)
        receive_message(args)

      _ ->
        exit("received unexpect message")
    end
  end
end
