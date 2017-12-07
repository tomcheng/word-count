Code.load_file("word_counter.ex", __DIR__)

ExUnit.start
ExUnit.configure trace: true

defmodule WordCounterTest do
  use ExUnit.Case, async: true

  test "counts words" do
    assert WordCounter.count("See Spot run.") == %{"SEE" => 1, "SPOT" => 1, "RUN" => 1}
    assert WordCounter.count("Run, Spot, run.") == %{"RUN" => 2, "SPOT" => 1}
  end
end
