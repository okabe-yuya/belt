defmodule Belt do
  def start do
    {:ok, pid_queue} = GenServer.start_link(Queue, [1, 2, 3, 4, 5, 6, 7, 8])
    Manager.start_link(pid_queue)

    pid_queue
  end
end
