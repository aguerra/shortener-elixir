defmodule Shortener.Core do
  alias Shortener.Storage

  @key_length Application.get_env(:shortener, :key_length, 8)
  @hostname   Application.get_env(:shortener, :hostname, "localhost")
  @port       Application.get_env(:shortener, :port, 8080)

  @alphanum "0123456789abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true)

  def key_length, do: @key_length
  def hostname, do: @hostname
  def port, do: @port

  def new_key(length \\ @key_length) do
    (1..length)
    |> Enum.reduce([], fn(_, acc) -> [Enum.random(@alphanum) | acc] end)
    |> Enum.join("")
  end

  def shorten_url(url) do
    key = new_key()
    Storage.put(Storage, key, url)
    %{url: url, link: "http://#{@hostname}:#{@port}/#{key}"}
  end

  def handle_key(key) when key == "version" do
    version = Application.spec(:shortener, :vsn)
    {200, %{version: to_string(version)}, []}
  end

  def handle_key(key) do
    url = Storage.get(Storage, key)
    unless is_nil(url) do
      {302, "", [{"location", url}]}
    else
      {404, %{error: "not found"}, []}
    end
  end
end
