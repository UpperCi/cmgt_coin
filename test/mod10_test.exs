defmodule Mod10Test do
  use ExUnit.Case
  alias Chain.Mod10
  doctest Mod10

  test "split text into ascii digits" do
    assert [1, 1, 6, 1, 0, 1, 1, 2, 0, 1, 1, 6] = Mod10.split_data("text")
  end

  # stap 4
  test "split data into blocks of 10, pad remaining digits" do
    assert [[1, 1, 6, 1, 0, 1, 1, 2, 0, 1], [1, 6, 0, 1, 2, 3, 4, 5, 6, 7]] =
             Mod10.split_data("text") |> Mod10.digits_to_blocks()
  end

  # stap 5, 6
  test "cross-sum digits, modulating all by 10" do
    assert [2, 7, 6, 2, 2, 4, 5, 7, 6, 8] =
             Mod10.split_data("text") |> Mod10.digits_to_blocks() |> Mod10.sum_blocks()
  end

  test "sha256 hash resulting block" do
    assert "d0b3cb0cc9100ef243a1023b2a129d15c28489e387d3f8b687a7299afb4b5079" =
             Mod10.split_data("text")
             |> Mod10.digits_to_blocks()
             |> Mod10.sum_blocks()
             |> Mod10.hash_block()

    assert "d0b3cb0cc9100ef243a1023b2a129d15c28489e387d3f8b687a7299afb4b5079" = Mod10.hash("text")
  end
end
