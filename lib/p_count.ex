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
end