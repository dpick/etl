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
    config = Mix.Config.read!("test/configs/file_to_file.exs")[:etl]

    Etl.run(struct(Etl.Config, config))

    {:ok, input} = File.read("test/fixtures/basic.csv")
    {:ok, output} = File.read("test/output/basic.csv")

    assert output == input
  end

  test "it copies a postgres table" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (1)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (2)", [])

    config = Mix.Config.read!("test/configs/postgres_to_file.exs")[:etl]

    Etl.run(struct(Etl.Config, config))

    {:ok, output} = File.read("test/output/test.csv")

    assert output == "1\r\n2\r\n"

    Postgrex.query!(pid, "DROP TABLE test", [])
  end
end
