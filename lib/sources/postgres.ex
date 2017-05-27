defmodule Etl.PostgresSource do
  @behaviour Etl.DataSource

  def tables(config) do
    {:ok, pid} = Postgrex.start_link(config.connection)

    result = Postgrex.query!(pid, "select table_name from information_schema.tables where table_schema = '#{config.schema}'", [])

    List.flatten(result.rows)
  end

  def pull(table, config) do
    {:ok, pid} = Postgrex.start_link(config.connection)

    result = Postgrex.query!(pid, "SELECT * FROM #{table}", [])

    result.rows
  end
end
