defmodule Chain.Mod10 do
  @moduledoc """
  Documentation for `Mod10`.
  """

  def split_data(data) do
    input =
      String.to_charlist(data)
      |> Enum.filter(fn c -> c != 32 end)
      |> Enum.map(fn c ->
        if c >= 48 && c <= 57 do
          c - 48
        else
          c
        end
      end)

    Enum.flat_map(input, fn n ->
      Integer.to_string(n)
      |> String.to_charlist()
      |> Enum.map(fn c -> c - 48 end)
    end)
  end

  def digits_to_blocks([]) do
    []
  end

  def digits_to_blocks(digits) do
    padding = Enum.to_list(0..9)
    [Enum.take(digits ++ padding, 10) | digits_to_blocks(Enum.drop(digits, 10))]
  end

  def add_blocks([], []) do
    []
  end

  def add_blocks([a | left], [b | right]) do
    [rem(a + b, 10) | add_blocks(left, right)]
  end

  def sum_blocks([sum]) do
    sum
  end

  def sum_blocks([sum, next | tail]) do
    sum_blocks([add_blocks(sum, next) | tail])
  end

  def hash_block(block) do
    :crypto.hash(:sha256, Enum.map(block, fn n -> n + 48 end) |> List.to_string())
    |> Base.encode16()
    |> String.downcase()
  end

  def hash(data) do
    data
    |> split_data
    |> digits_to_blocks
    # |> IO.inspect()
    |> sum_blocks
    |> hash_block
  end
end
