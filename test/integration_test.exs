defmodule IntegrationTest do
  use ExUnit.Case, async: true

  alias Shortener.Core

  setup do
    hostname = Core.hostname()
    port = Core.port()
    %{base_url: "http://#{hostname}:#{port}/"}
  end

  test "get the version", %{base_url: base_url} do
    response = HTTPoison.get!("#{base_url}version")
    %{"version" => version} = Jason.decode!(response.body)

    assert response.status_code == 200
    assert version == Application.spec(:shortener, :vsn) |> to_string
  end

  test "only accepts json", %{base_url: base_url} do
    {:ok, response} = HTTPoison.post("#{base_url}", "body")

    assert response.status_code == 415
  end

  test "shorten an url and use the key", %{base_url: base_url} do
    body = Jason.encode!(%{url: "http://anything"})
    response = HTTPoison.post!("#{base_url}", body, [{"Content-Type", "application/json"}])

    assert response.status_code == 201

    %{"link" => link} = Jason.decode!(response.body)
    response = HTTPoison.get!(link)

    assert response.status_code == 302
    {_, location} = List.keyfind(response.headers, "location", 0)
    assert location == "http://anything"
  end

  test "access non-existent key", %{base_url: base_url} do
    {:ok, response} = HTTPoison.get("#{base_url}non-existent")

    assert response.status_code == 404
  end
end
