defmodule WordCounter do
  def count(passage, existing_counts \\ %{}) do
    passage
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(" ")
    |> Enum.reduce(existing_counts, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
