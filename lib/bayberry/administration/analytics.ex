defmodule Bayberry.Administration.Analytics do
  alias Bayberry.Geolocation
  alias Bayberry.Geolocation.Point
  import Ecto.Query, only: [from: 2]

  def geolocate(conn) do
    conn
    |> forwarded_for
    |> ip_integer
    |> query_location
    |> Geolocation.one()
    |> (fn a -> a || %{} end).()
  end

  def ip_address(conn) do
    conn
    |> forwarded_for
    |> ip_string
  end

  def user_agent(conn) do
    conn
    |> Plug.Conn.get_req_header("user-agent")
    |> Enum.at(0)
  end

  defp ip_integer(ip) do
    case ip do
      {192, 168, _, _} -> 0
      {172, a, _, _} when a > 15 and a < 32 -> 0
      {127, _, _, _} -> 0
      {10, _, _, _} -> 0
      {a, b, c, d} ->
        :math.pow(256, 3) * a + :math.pow(256, 2) * b + 256 * c + d
        |> trunc
    end
  end

  defp ip_string({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end

  defp ip_string?(ip) do
    String.match?(ip, ~r/[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}/)
  end

  defp forwarded_for(conn) do
    conn
    |> Plug.Conn.get_req_header("x-forwarded-for")
    |> Enum.at(0)
    |> (fn ips -> "#{ips}" end).()
    |> String.split(",")
    |> Enum.at(0)
    |> (fn ip -> if ip_string?(ip), do: ip, else: "0.0.0.0" end).()
    |> String.split(".")
    |> Enum.map(fn a -> Integer.parse(a) end)
    |> Enum.map(fn {a, _} -> a end)
    |> List.to_tuple()
  end

  defp query_location(ip) do
    from p in Point,
      where: p.ip_from <= ^ip and ^ip < p.ip_to,
      select: %{latitude: p.latitude, longitude: p.longitude}
  end
end
