defmodule Belt do
  def start do
    {:ok, pid_queue} = GenServer.start_link(Queue, [])
    Manager.start_link(pid_queue)

    measuring_device(pid_queue)
  end

  def measuring_device(pid_queue) do
    GenServer.cast(pid_queue, {:push, {:rand.uniform(100), :rand.uniform(100)}})
    Process.sleep(100)

    measuring_device(pid_queue)
  end
end
