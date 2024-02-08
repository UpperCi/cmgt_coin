defmodule Chain.CLI do
  def main(args) do
    args
    |> Enum.join(" ")
    |> handle_args()
  end

  def handle_args("mine " <> user) do
    Chain.mine(user)
    IO.puts(user)
  end

  def handle_args(command) do
    IO.puts("Error: command '" <> command <> "' not recognized.")
  end
end
