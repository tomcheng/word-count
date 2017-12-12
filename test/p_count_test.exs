defmodule P_COUNT.Test do
  use ExUnit.Case
  doctest P_COUNT

  test "count words from multiple files" do
    assert P_COUNT.count_files("test/test_data/*.txt") ==  %{"SEE" => 1, "SPOT" => 2, "RUN" => 3, "FOO" => 1, "BAR" => 1}
  end

  @tag :timing
  test "counting lots of files (parallelized by file)" do
    P_COUNT.count_files
  end

  @tag :timing
  test "counting lots of files (parallelized by chunk)" do
    P_COUNT.count_files_by_chunk
  end

  @tag :timing
  test "counting lots of files (parallelized by chunk and file)" do
    P_COUNT.count_files_by_chunk_and_file
  end

  @tag :timing
  test "counting a big file" do
    P_COUNT.count_file("data/war_peace_text.txt")
  end
end
