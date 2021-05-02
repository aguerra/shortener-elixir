defmodule Shortener.CoreTest do
  use ExUnit.Case, async: true

  test "creates a key with the default length" do
    assert Shortener.Core.new_key |> String.length == Shortener.Core.key_length
  end

  test "creates a key with a custom length" do
    assert Shortener.Core.new_key(3) |> String.length == 3
  end
end
