defmodule Etl.DataSink do
  @moduledoc ~S"""
  Specification of an etl data sink.
  """

  @type config :: Etl.Config
  @type data :: Stream
  @type table :: String

  @doc """
    Writes data to the sink.
  """
  @callback push(data, config, table) :: any
end
