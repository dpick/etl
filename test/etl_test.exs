defmodule EtlTest do
  use ExUnit.Case
  doctest Etl

  setup do
    File.mkdir("test/output")

    on_exit fn ->
      File.rm_rf("test/output")
    end
  end

  test "it copies a basic file" do
    Etl.run(
      struct(
        Etl.Config,
        [
          source: "test/fixtures/basic.csv",
          destination: "test/output/",
          type: "file",
        ]
      )
    )

    {:ok, input} = File.read("test/fixtures/basic.csv")
    {:ok, output} = File.read("test/output/basic.csv")

    assert output == input
  end
end
