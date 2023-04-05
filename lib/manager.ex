defmodule Manager do
  use Supervisor

  def start_link(pid_queue) do
    {:ok, pid} = Supervisor.start_link(__MODULE__, {self(), pid_queue}, name: __MODULE__)

    children =
      Supervisor.which_children(pid)
      |> Enum.reduce(%{}, fn {module, pid, _, _}, acc -> Map.put(acc, module, pid) end)

    pid_manager = spawn(fn -> process(children, pid_queue) end)
    %{supervisor: pid, children: children, manager: pid_manager}
  end

  def init({_from, _pid_queue}) do
    children = [
      %{id: "Plugins.Saver", start: {Plugins.Saver, :start_link, []}, restart: :permanent},
      %{id: "Plugins.Viewer", start: {Plugins.Viewer, :start_link, []}, restart: :permanent}
    ]

    Supervisor.init(children, strategy: :one_for_all, max_restarts: 10)
  end

  defp process(children, pid_queue) do
    value = GenServer.call(pid_queue, :pop)

    case value do
      {:ok, value} ->
        send(children["Plugins.Saver"], {:value, self(), value})
        send(children["Plugins.Viewer"], {:value, self(), value})
        Process.sleep(500)
        process(children, pid_queue)

      {:empty, _} ->
        process(children, pid_queue)
    end
  end
end
