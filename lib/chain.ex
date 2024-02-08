defmodule Chain do
  @moduledoc """
  Documentation for `Chain`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chain.hello()
      :world

  """
  alias Chain.Api
  alias Chain.Mod10

  def hello do
    :world
  end

  def add(a, b) do
    a + b
  end

  def find_nonce(base, current) do
    hash = (base <> Integer.to_string(current)) |> Mod10.hash()
    case hash do
      "0000" <> _rest -> Integer.to_string(current)
      _ -> find_nonce(base, current + 1)
    end
  end

  def mine_coin(user) do
    %{
      "blockchain" => %{
        "hash" => hash,
        "nonce" => nonce,
        "timestamp" => timestamp,
        "data" => data
      },
      "timestamp" => new_timestamp,
      "transactions" => [
        %{
          "from" => new_from, "to" => new_to, "amount" => new_amount, "timestamp" => new_tr_timestamp
        }
      ]
    } = Api.get_next()

    [%{"from" => tr_from, "to" => tr_to, "amount" => tr_amount, "timestamp" => tr_timestamp}] =
      data

    new_hash =
      (hash <>
         tr_from <>
         tr_to <>
         Integer.to_string(tr_amount) <>
         Integer.to_string(tr_timestamp) <> Integer.to_string(timestamp) <> nonce)
      |> IO.inspect() |> Mod10.hash()

      base = (new_hash <>
         new_from <>
         new_to <>
         Integer.to_string(new_amount) <>
         Integer.to_string(new_tr_timestamp) <> Integer.to_string(new_timestamp))

    nonce = find_nonce(base, 0)
    IO.puts(nonce)

    Api.chain_block(user, nonce)
  end
end
