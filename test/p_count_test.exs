defmodule P_COUNT.Test do
  use ExUnit.Case
  doctest P_COUNT

  test "count words from multiple files" do
    assert P_COUNT.count_files("test/test_data/*.txt") ==  %{"SEE" => 1, "SPOT" => 2, "RUN" => 3, "FOO" => 1, "BAR" => 1}
  end

  @tag :timing
  test "counting lots of files concurrently" do
    P_COUNT.count_files("data/*.txt")
  end
end
