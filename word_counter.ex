defmodule WordCounter do
  def count(passage) do
    passage
    |> String.replace(~r/[^\w ]/, "")
    |> String.upcase
    |> String.split(" ")
    |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
