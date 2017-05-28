defmodule Etl do
  @moduledoc """
  Documentation for Etl.
  """

  def run(config) do
    tables = config.source_adapter.tables(config)

    Enum.each(tables, fn(table) ->
      table
      |> config.source_adapter.pull(config)
      |> config.destination_adapter.push(config, table)
    end)
  end
end
