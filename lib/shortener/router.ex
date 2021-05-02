defmodule Shortener.Router do
  use Plug.Router
  use Plug.ErrorHandler

  import Shortener.Core

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  post "/" do
    {status, data} =
      case conn.body_params do
        %{"url" => url} -> {201, shorten_url(url)}
        _               -> {400, %{error: "missing url"}}
      end
    send_json(conn, status, data)
  end

  get "/:key" do
    {status, data, extra_headers} = handle_key(key)
    send_json(conn, status, data, extra_headers)
  end

  match _ do
    send_json(conn, 404, %{error: "not found"})
  end

  def handle_errors(conn, _) do
    send_json(conn, conn.status, %{error: "something went wrong"})
  end

  defp send_json(conn, status, data) do
    body = Jason.encode!(data)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  defp send_json(conn, status, data, extra_headers) do
    extra_headers
    |> Enum.reduce(conn, fn {k, v}, acc -> put_resp_header(acc, k, v) end)
    |> send_json(status, data)
  end
end
