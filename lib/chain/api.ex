defmodule Chain.Api do
  @moduledoc """
  Documentation for `Api`.
  """

  def get_blockchain() do
    {:ok, body} =
      HTTPoison.get("https://programmeren9.cmgt.hr.nl:8000/api/blockchain", []
      )

    Map.get(body, :body) |> Jason.decode!()
  end

  def get_next() do
    {:ok, body} =
      HTTPoison.get("https://programmeren9.cmgt.hr.nl:8000/api/blockchain/next", []
      )

    case Map.get(body, :body) |> Jason.decode!() do
      %{"open" => false} = data -> {:wait, data}
      %{"open" => true} = data -> {:ok, data}
    end
  end

  def chain_block(user, nonce) do
    request_body = Jason.encode!(%{nonce: nonce, user: user})

    {:ok, body} =
      HTTPoison.post(
        "https://programmeren9.cmgt.hr.nl:8000/api/blockchain",
        request_body,
        [{"Content-Type", "application/json"}]
      )

    Map.get(body, :body) |> Jason.decode!()
  end
end
