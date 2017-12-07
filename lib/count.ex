defmodule COUNT do
  def pcount_files(path_wildcard) do
    caller = self()

    path_wildcard
    |> Path.wildcard
    |> Enum.map(fn path ->
         spawn(fn ->
           send(caller, pcount_file(path))
         end)
       end)
    |> Enum.reduce(%{}, fn (_, acc) ->
      receive do
        msg -> merge_counts(acc, msg)
      end
    end)
  end

  def pcount_file(path) do
    caller = self()

    path
    |> File.stream!
    |> Enum.chunk_every(1000)
    |> Enum.map(fn lines ->
         spawn(fn ->
           send(caller, Enum.reduce(lines, %{}, fn(x, acc) -> count_line(x, acc) end))
         end)
       end)
    |> Enum.reduce(%{}, fn(_, acc) ->
         receive do
           msg -> merge_counts(acc, msg)
         end
       end)
  end

  def count_files(path_wildcard) do
    path_wildcard
    |> Path.wildcard
    |> Enum.reduce(%{}, fn(x, acc) -> count_file(x, acc) end)
  end

  def count_file(path, existing_counts \\ %{}) do
    path
    |> File.stream!
    |> Enum.reduce(existing_counts, fn(x, acc) -> count_line(x, acc) end)
  end

  def count_line(passage, existing_counts \\ %{}) do
    passage
    |> String.trim
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(~r/ +/)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce(existing_counts, fn(x, acc) ->
         Map.update(acc, x, 1, &(&1 + 1))
       end)
  end

  def merge_counts(larger, smaller) do
    Enum.reduce(smaller, larger, fn({term, count}, acc) ->
      Map.update(acc, term, count, &(&1 + count))
    end)
  end

  def sort_counts(counts) do
    counts
    |> Map.to_list
    |> Enum.sort_by(fn({_, count}) -> -count end)
  end
end
