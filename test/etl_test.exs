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

  test "it copies a postgres table to a file" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS public.test (id integer)", [])
    Postgrex.query!(pid, "INSERT INTO public.test VALUES (1)", [])
    Postgrex.query!(pid, "INSERT INTO public.test VALUES (2)", [])

    config = Mix.Config.read!("test/configs/postgres_to_file.exs")[:etl]

    Etl.run(struct(Etl.Config, config))

    {:ok, output} = File.read("test/output/test.csv")

    assert output == "1\r\n2\r\n"

    Postgrex.query!(pid, "DROP TABLE public.test", [])
  end

  test "it copies a postgres table to another postgres schema" do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", database: "postgres", username: "postgres")

    Postgrex.query!(pid, "CREATE TABLE IF NOT EXISTS public.test (id integer)", [])
    Postgrex.query!(pid, "INSERT INTO public.test VALUES (1)", [])
    Postgrex.query!(pid, "INSERT INTO public.test VALUES (2)", [])

    config = Mix.Config.read!("test/configs/postgres_to_postgres.exs")[:etl]

    Etl.run(struct(Etl.Config, config))

    output = Postgrex.query!(pid, "SELECT * FROM test.test", [])

    assert output.rows == [[1], [2]]

    Postgrex.query!(pid, "DROP TABLE IF EXISTS public.test", [])
    Postgrex.query!(pid, "DROP SCHEMA test CASCADE", [])
  end
end
