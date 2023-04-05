defmodule Queue do
  use GenServer

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call(:pop, _from, [head | tail]), do: {:reply, {:ok, head}, tail}
  def handle_call(:pop, _from, []), do: {:reply, {:empty, nil}, []}

  @impl true
  def handle_cast({:push, element}, state), do: {:noreply, [element | state]}
end
