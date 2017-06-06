defmodule Etl do
  @moduledoc """
  Documentation for Etl.
  """

  def run(config) do
    tables = config.source_adapter.tables(config)

    Enum.each(tables, fn(table) ->
      data = config.source_adapter.pull(table, config)
      source_schema = config.source_adapter.table_schema(table, config)

      destination_schema = config.destination_adapter.table_schema(table, config)

      if source_schema != destination_schema do
        config.destination_adapter.recreate_schema(table, config, source_schema)
      end

      config.destination_adapter.push(data, config, table)
    end)
  end
end
