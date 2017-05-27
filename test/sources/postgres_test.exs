defmodule Etl.PostgresSourceTest do
  use ExUnit.Case
  doctest Etl

  test "it reads the table names from PG" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])
    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test2 (id integer)", [])

    config = struct(
      Etl.Config,
      [
        type: "postgres",
        destination: "test/output",
        schema: "public",
        connection: [
          hostname: "localhost",
          database: "postgres",
          username: "postgres"
        ]
      ]
    )

    assert (Etl.PostgresSource.tables(config) -- ["test", "test2"]) == []

    Postgrex.query!(pid, "DROP TABLE test", [])
    Postgrex.query!(pid, "DROP TABLE test2", [])
  end

  test "Given a connection and a table it pulls the data from PG" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (1)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (2)", [])

    config = struct(
      Etl.Config,
      [
        type: "postgres",
        destination: "test/output",
        schema: "public",
        connection: [
          hostname: "localhost",
          database: "postgres",
          username: "postgres"
        ]
      ]
    )

    assert [[1], [2]] == Etl.PostgresSource.pull("test", config)

    Postgrex.query!(pid, "DROP TABLE test", [])
  end
end
