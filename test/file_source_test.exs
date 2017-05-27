defmodule Etl.FileSourceTest do
  use ExUnit.Case
  doctest Etl.FileSource

  test "it pulls table names properly" do
    config = struct(Etl.Config, [source: "test/fixtures/basic.csv", destination: "test/fixtures/output.csv"])

    assert Etl.FileSource.tables(config) == ["basic"]
  end
end
