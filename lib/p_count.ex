defmodule P_COUNT do
  def count_files(path_wildcard  \\ "data/*") do
    caller = self()

    path_wildcard
    |> Path.wildcard
    |> Enum.map(fn path ->
      spawn(fn ->
        send(caller, {:result, COUNT.count_file(path)})
      end)
    end)
    |> Enum.reduce(%{}, fn (_, acc) ->
      receive do
        {:result, counts} -> COUNT.merge_counts(acc, counts)
      end
    end)
  end

  def count_files_by_chunk(path_wildcard \\ "data/*") do
    path_wildcard
    |> Path.wildcard
    |> Enum.reduce(%{}, fn path, counts -> COUNT.merge_counts(counts, count_file(path)) end)
  end

  def count_files_by_chunk_and_file(path_wildcard \\ "data/*") do
    caller = self()

    path_wildcard
    |> Path.wildcard
    |> Enum.map(fn path ->
      spawn(fn ->
        send(caller, {:result, count_file(path)})
      end)
    end)
    |> Enum.reduce(%{}, fn (_, acc) ->
      receive do
        {:result, counts} -> COUNT.merge_counts(acc, counts)
      end
    end)
  end

  def count_file(path) do
    caller = self()

    path
    |> File.stream!
    |> Enum.chunk_every(2000)
    |> Enum.map(fn lines ->
      spawn(fn ->
        send(caller, {:result, Enum.reduce(lines, %{}, &COUNT.count_line/2)})
      end)
    end)
    |> Enum.reduce(%{}, fn (_, total_counts) ->
      receive do
        {:result, chunk_counts} -> COUNT.merge_counts(total_counts, chunk_counts)
      end
    end)
  end
end