defmodule Shortener.StorageTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, storage} = Shortener.Storage.start_link(name: :storage_test)
    %{storage: storage}
  end

  test "stores values by key", %{storage: storage} do
    assert Shortener.Storage.get(storage, "key") == nil

    Shortener.Storage.put(storage, "key", "value")
    assert Shortener.Storage.get(storage, "key") == "value"
  end
end
