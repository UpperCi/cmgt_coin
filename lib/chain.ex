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

  def mine(user, {:ok, %{"countdown" => time} = data}) do
    task = Task.async(fn -> mine_coin(user, data) end)
    Task.await(task, time)
    mine(user)
  end

  def mine(user, {:wait, %{"countdown" => time} = _data}) do
    :timer.sleep(time)
    mine(user)
  end

  def mine(user) do
    mine(user, Api.get_next())
  end

  def mine_coin(user, %{
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
    } = _next) do
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

    Api.chain_block(user, nonce) |> IO.inspect()
  end
end
