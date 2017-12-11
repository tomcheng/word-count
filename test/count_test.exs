defmodule COUNT.Test do
  use ExUnit.Case
  doctest COUNT

  test "counts words" do
    assert COUNT.count_line("See Spot run.") == %{"SEE" => 1, "SPOT" => 1, "RUN" => 1}
    assert COUNT.count_line("Run, Spot, run.") == %{"RUN" => 2, "SPOT" => 1}
    assert COUNT.count_line("foo bar ") == %{"FOO" => 1, "BAR" => 1}
  end

  test "update existing counts" do
    assert COUNT.count_line("foo bar", %{"FOO" => 1, "BAZ" => 1}) == %{"FOO" => 2, "BAZ" => 1, "BAR" => 1}
  end

  test "count words from a file" do
    assert COUNT.count_file("test/test_data/spot.txt") == %{"SEE" => 1, "SPOT" => 2, "RUN" => 3}
  end

  test "count words from multiple files" do
    assert COUNT.count_files("test/test_data/*.txt") ==  %{"SEE" => 1, "SPOT" => 2, "RUN" => 3, "FOO" => 1, "BAR" => 1}
  end

  test "sorts counts" do
    assert COUNT.sort_counts(%{"FOO" => 10, "BAR" => 1, "BAZ" => 5}) == [{"FOO", 10}, {"BAZ", 5}, {"BAR", 1}]
  end

  test "merge counts" do
    assert COUNT.merge_counts(%{"FOO" => 1, "BAR" => 3}, %{"FOO" => 1, "BAZ" => 3}) == %{"FOO" => 2, "BAR" => 3, "BAZ" => 3}
  end

  @tag :timing
  test "counting lots of files" do
    COUNT.count_files("data/*.txt")
  end
end
