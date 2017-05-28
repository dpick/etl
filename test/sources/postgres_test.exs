defmodule Etl.PostgresSourceTest do
  use ExUnit.Case
  doctest Etl

  def load_config(file) do
    struct(Etl.Config, Mix.Config.read!(file)[:etl])
  end

  test "it reads the table names from PG" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])
    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test2 (id integer)", [])

    config = load_config("test/configs/postgres_to_file.exs")

    assert (Etl.PostgresSource.tables(config) -- ["test", "test2"]) == []

    Postgrex.query!(pid, "DROP TABLE test", [])
    Postgrex.query!(pid, "DROP TABLE test2", [])
  end

  test "Given a connection and a table it pulls the data from PG" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (1)", [])
    Postgrex.query!(pid, "INSERT INTO test VALUES (2)", [])

    config = load_config("test/configs/postgres_to_file.exs")

    assert [[1], [2]] == Etl.PostgresSource.pull("test", config)

    Postgrex.query!(pid, "DROP TABLE test", [])
  end

  test "it returns a tables schema" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS test (id integer)", [])

    config = load_config("test/configs/postgres_to_file.exs")

    assert [["id", "integer"]] == Etl.PostgresSource.table_schema("test", config)

    Postgrex.query!(pid, "DROP TABLE test", [])
  end
end
