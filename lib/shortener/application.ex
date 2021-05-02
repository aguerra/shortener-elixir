defmodule Shortener.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    port = Shortener.Core.port()
    children = [
      {Plug.Cowboy, scheme: :http, plug: Shortener.Router, options: [port: port]},
      Shortener.Storage,
    ]
    opts = [strategy: :one_for_one, name: Shortener.Supervisor]
    Logger.info("Starting application...")
    Supervisor.start_link(children, opts)
  end
end
