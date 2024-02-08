defmodule ChainTest do
  use ExUnit.Case
  doctest Chain

  test "greets the world" do
    assert Chain.hello() == :world
  end

  test "sums numbers" do
    assert Chain.add(5, 10) == 15
  end
end
