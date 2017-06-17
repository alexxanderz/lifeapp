defmodule LifeApp.UserSocket do
  use Phoenix.Socket

  channel "rooms:*", LifeApp.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end

defimpl Poison.Encoder, for: Tuple do
  def encode(tuple, _options) do
    tuple
    |> Tuple.to_list
    |> Poison.encode!
  end
end