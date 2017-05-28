defmodule Etl.Config do
  defstruct [
    :source,
    :source_adapter,
    :destination_adapter,
    :destination,
    :connection,
    :schema
  ]
end
