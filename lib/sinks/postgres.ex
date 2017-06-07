defmodule Etl.PostgresSink do
  @behaviour Etl.DataSink

  def push(data, config, table) do
    {:ok, pid} = Postgrex.start_link(config.destination_connection)

    Enum.each(data, fn(row) ->
      sql = "INSERT INTO #{config.destination_schema}.#{table} VALUES (#{Enum.join(row, ",")})"
      Postgrex.query!(pid, sql, [])
    end)
  end

  def generate_create_sql(table, schema, pg_schema) do
    table_string = schema
                   |> Enum.map(fn [column, type] -> "#{column} #{type}" end)
                   |> Enum.join(",\n")

    """
    CREATE TABLE IF NOT EXISTS #{pg_schema}.#{table} (
    #{table_string}
    )
    """
  end

  def recreate_schema(table, config, source_schema) do
    {:ok, pid} = Postgrex.start_link(config.destination_connection)

    Postgrex.query!(pid, "DROP TABLE IF EXISTS #{table}", [])
    Postgrex.query!(pid, "CREATE SCHEMA IF NOT EXISTS #{config.destination_schema}", [])
    sql = generate_create_sql(table, source_schema, config.destination_schema)
    Postgrex.query!(pid, sql, [])
  end

  def table_schema(table, config) do
    {:ok, pid} = Postgrex.start_link(config.destination_connection)

    query = """
    SELECT column_name, data_type
    FROM information_schema.columns WHERE table_name = '#{table}'
      AND table_schema = '#{config.destination_schema}'
    ORDER BY ordinal_position
    """

    result = Postgrex.query!(pid, query, [])

    result.rows
  end
end
