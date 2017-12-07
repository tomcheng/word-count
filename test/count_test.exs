defmodule COUNTTest do
  use ExUnit.Case
  doctest COUNT

  test "counts words" do
    assert COUNT.count("See Spot run.") == %{"SEE" => 1, "SPOT" => 1, "RUN" => 1}
    assert COUNT.count("Run, Spot, run.") == %{"RUN" => 2, "SPOT" => 1}
  end

  test "update existing counts" do
    assert COUNT.count("foo bar", %{"FOO" => 1, "BAZ" => 1}) == %{"FOO" => 2, "BAZ" => 1, "BAR" => 1}
  end

  test "counts words from a file" do
    assert COUNT.count_file("./inputs/test.txt") == %{"SEE" => 1, "SPOT" => 2, "RUN" => 3}
  end
end
