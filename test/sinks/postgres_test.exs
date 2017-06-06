defmodule Etl.PostgresSinkTest do
  use ExUnit.Case
  doctest Etl

  def load_config(file) do
    struct(Etl.Config, Mix.Config.read!(file)[:etl])
  end

  test "generates a create table query" do
    assert Etl.PostgresSink.generate_create_sql("test", [["id", "integer"], ["body", "varchar"]], "public") == """
    CREATE TABLE IF NOT EXISTS public.test (
    id integer,
    body varchar
    )
    """
  end
end
