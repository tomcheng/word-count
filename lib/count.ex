defmodule COUNT do
  def count_files(path_wildcard) do
    path_wildcard
    |> Path.wildcard
    |> Enum.reduce(%{}, fn(x, acc) -> count_file(x, acc) end)
  end

  def count_file(path, existing_counts \\ %{}) do
    path
    |> File.stream!
    |> Enum.reduce(existing_counts, fn(x, acc) -> count(x, acc) end)
  end

  def count(passage, existing_counts \\ %{}) do
    passage
    |> String.trim
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(~r/ +/)
    |> Enum.reduce(existing_counts, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def sort_counts(counts) do
    counts
    |> Map.to_list
    |> Enum.sort_by(fn({_, count}) -> -count end)
  end
end
