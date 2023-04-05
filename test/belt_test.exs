defmodule BeltTest do
  use ExUnit.Case
  doctest Belt

  test "greets the world" do
    assert Belt.hello() == :world
  end
end
