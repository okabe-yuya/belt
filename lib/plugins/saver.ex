defmodule Plugins.Saver do
  @behaviour Plugins.PluginBehavior

  def start_link do
    pid = spawn_link(__MODULE__, :receive_message, [0])
    {:ok, pid}
  end

  def receive_message(args) do
    receive do
      {:value, from, value} ->
        IO.puts("saver!")
        IO.puts(value)
        receive_message(args)

      _ ->
        exit("received unexpect message")
    end
  end
end
