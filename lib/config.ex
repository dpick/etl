defmodule Etl.Config do
  defstruct [
    :source,
    :source_adapter,
    :destination_adapter,
    :destination,
    :source_connection,
    :destination_connection,
    :source_schema,
    :destination_schema
  ]
end
