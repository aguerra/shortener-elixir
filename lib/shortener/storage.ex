defmodule Shortener.Storage do
  use Agent

  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)
    Agent.start_link(fn -> %{} end, name: name)
  end

  def get(storage, key) do
    Agent.get(storage, &Map.get(&1, key))
  end

  def put(storage, key, value) do
    Agent.update(storage, &Map.put(&1, key, value))
  end
end
