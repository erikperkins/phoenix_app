defmodule BayberryWeb.NlpSocket do
  use Phoenix.Socket

  channel "nlp:*", BayberryWeb.NlpChannel

  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end