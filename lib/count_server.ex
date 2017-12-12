defmodule COUNT_SERVER do
  use GenServer

  def start do
    GenServer.start_link(COUNT_SERVER, %{})
  end

  def get_counts(pid) do
    GenServer.call(pid, :get_counts)
  end

  def process_files(pid, wildcard) do
    wildcard
    |> Path.wildcard
    |> Enum.each(fn path ->
      process_file(pid, path)
    end)
    :ok
  end

  def process_file(pid, file_path) do
    spawn(fn ->
      GenServer.cast(pid, {:add_file_counts, P_COUNT.count_file(file_path)})
    end)
    :ok
  end

  def handle_call(:get_counts, _, state) do
    {:reply, COUNT.sort_counts(state), state}
  end

  def handle_cast({:add_file_counts, file_counts}, state) do
    {:noreply, COUNT.merge_counts(state, file_counts)}
  end
end