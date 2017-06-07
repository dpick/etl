defmodule Etl.DataSink do
  @moduledoc ~S"""
  Specification of an etl data sink.
  """

  @type config :: Etl.Config
  @type data :: Stream
  @type table :: String
  @type source_schema :: Array

  @doc """
    Writes data to the sink.
  """
  @callback push(data, config, table) :: any
  @callback table_schema(table, config) :: any
  @callback recreate_schema(table, config, source_schema) :: any
end
