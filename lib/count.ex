defmodule COUNT do
  def count_files(path_wildcard \\ "data/*") do
    path_wildcard
    |> Path.wildcard
    |> Enum.reduce(%{}, fn path, counts -> merge_counts(counts, count_file(path)) end)
  end

  def count_file(path) do
    path
    |> File.stream!
    |> Enum.reduce(%{}, &count_line/2)
  end

  def count_line(passage, existing_counts \\ %{}) do
    passage
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(~r/ +/)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce(existing_counts, fn word, counts ->
       Map.update(counts, word, 1, &(&1 + 1))
    end)
  end

  def merge_counts(larger, smaller) do
    Enum.reduce(smaller, larger, fn {term, count}, acc ->
      Map.update(acc, term, count, &(&1 + count))
    end)
  end

  def sort_counts(counts) do
    counts
    |> Map.to_list
    |> Enum.sort_by(fn {_, count} -> -count end)
  end
end
