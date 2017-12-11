defmodule P_COUNT do
  def count_files(path_wildcard) do
    parent_pid = self()

    path_wildcard
    |> Path.wildcard
    |> Enum.map(fn path ->
      spawn(fn ->
        send(parent_pid, COUNT.count_file(path))
      end)
    end)
    |> Enum.reduce(%{}, fn (_, acc) ->
      receive do
        msg -> COUNT.merge_counts(acc, msg)
      end
    end)
  end

  def count_file(path) do
    parent_pid = self()

    path
    |> File.stream!
    |> Enum.chunk_every(2000)
    |> Enum.map(fn lines ->
      spawn(fn ->
        send(parent_pid, Enum.reduce(lines, %{}, &COUNT.count_line/2))
      end)
    end)
    |> Enum.reduce(%{}, fn (_, acc) ->
      receive do
        msg -> COUNT.merge_counts(acc, msg)
      end
    end)
  end
end