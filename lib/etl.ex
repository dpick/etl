defmodule Etl do
  @moduledoc """
  Documentation for Etl.
  """

  def run(config) do
    tables = config |> Etl.FileSource.tables

    Enum.each(tables, fn(table) ->
      table
      |> Etl.FileSource.pull(config)
      |> Etl.FileSink.push(config, table)
    end)
  end
end
