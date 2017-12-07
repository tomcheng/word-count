defmodule COUNT.Test do
  use ExUnit.Case
  doctest COUNT

  test "counts words" do
    assert COUNT.count("See Spot run.") == %{"SEE" => 1, "SPOT" => 1, "RUN" => 1}
    assert COUNT.count("Run, Spot, run.") == %{"RUN" => 2, "SPOT" => 1}
    assert COUNT.count("foo bar ") == %{"FOO" => 1, "BAR" => 1}
  end

  test "update existing counts" do
    assert COUNT.count("foo bar", %{"FOO" => 1, "BAZ" => 1}) == %{"FOO" => 2, "BAZ" => 1, "BAR" => 1}
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

  @tag :timing
  test "timing" do
    COUNT.count_files("data/*.txt")
  end
end
