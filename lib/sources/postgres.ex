defmodule Etl.PostgresSource do
  @behaviour Etl.DataSource

  def tables(config) do
    {:ok, pid} = Postgrex.start_link(config.source_connection)

    result = Postgrex.query!(pid, "select table_name from information_schema.tables where table_schema = '#{config.source_schema}'", [])

    List.flatten(result.rows)
  end

  def pull(table, config) do
    {:ok, pid} = Postgrex.start_link(config.source_connection)

    result = Postgrex.query!(pid, "SELECT * FROM #{config.source_schema}.#{table}", [])

    result.rows
  end

  def table_schema(table, config) do
    {:ok, pid} = Postgrex.start_link(config.source_connection)

    query = """
    SELECT column_name, data_type
    FROM information_schema.columns WHERE table_name = '#{table}'
    ORDER BY ordinal_position
    """

    result = Postgrex.query!(pid, query, [])

    result.rows
  end
end
