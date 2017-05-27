defmodule Etl.DataSink do
  @moduledoc ~S"""
  Specification of an etl data sink.
  """

  @type location :: String
  @type data :: Stream

  @doc """
    Writes data to the sink.
  """
  @callback push(data, location) :: any
end
