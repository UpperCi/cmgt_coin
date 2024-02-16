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

  defp mash_data(data) do
    data
    |> Enum.map(fn raw_data ->
      %{
        "from" => from,
        "to" => to,
        "amount" => amount,
        "timestamp" => timestamp
      } = raw_data

      from <> to <> Integer.to_string(amount) <> Integer.to_string(timestamp)
    end)
    |> Enum.join()
  end

  def mine_coin(
        user,
        %{
          "blockchain" => %{
            "hash" => hash,
            "nonce" => nonce,
            "timestamp" => timestamp,
            "data" => data
          },
          "timestamp" => new_timestamp,
          "transactions" => transactions
        } = _next
      ) do
    new_hash =
      (hash <>
         mash_data(data) <>
         Integer.to_string(timestamp) <> nonce)
      |> IO.inspect()
      |> Mod10.hash()

    base =
      new_hash <>
        mash_data(transactions) <>
        Integer.to_string(new_timestamp)

    nonce = find_nonce(base, 0)

    Api.chain_block(user, nonce) |> IO.inspect()
  end
end
