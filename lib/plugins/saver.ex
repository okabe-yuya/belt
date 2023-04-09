defmodule Plugins.Saver do
  @behaviour Plugins.PluginBehavior
  @save_dir "files"
  @max_records_per_file 1000

  def start_link do
    pid = spawn_link(__MODULE__, :receive_message, [init_states(1)])
    {:ok, pid}
  end

  def receive_message(state) do
    receive do
      {:value, from, {x_point, y_point}} ->
        %{first_write_date: fwd, file: file, current_no: current_no, records: records} = state

        if records < @max_records_per_file do
          IO.binwrite(file, "#{x_point},#{y_point}\n")
          next_state = %{state | records: records + 1}

          receive_message(next_state)
        else
          File.close(file)
          file_no = if Date.diff(date_now(), fwd) > 1, do: 1, else: current_no + 1
          new_state = init_states(file_no)

          IO.binwrite(new_state.file, "#{x_point},#{y_point}\n")
          next_state = %{new_state | records: 1}
          receive_message(next_state)
        end

      _ ->
        exit("received unexpect message")
    end
  end

  def init_states(file_no) do
    date = date_now()
    filename = "#{Calendar.strftime(date, "%Y%m%d")}_#{file_no}.txt"
    {:ok, file} = File.open("#{@save_dir}/#{filename}", [:append])

    %{first_write_date: date, file: file, current_no: file_no, records: 0}
  end

  defp date_now do
    with {{year, month, date}, _} <- :calendar.local_time(),
         {:ok, ex_date} = Date.new(year, month, date),
         do: ex_date
  end
end
