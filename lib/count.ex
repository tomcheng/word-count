defmodule COUNT do
  def count_file(path) do
    path
    |> File.stream!
    |> Enum.reduce(%{}, fn(x, acc) -> count(x, acc) end)
  end

  def count(passage, existing_counts \\ %{}) do
    passage
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(" ")
    |> Enum.reduce(existing_counts, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
