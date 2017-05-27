defmodule Etl.Config do
  defstruct [:source, :source_type, :destination_type, :destination, :connection, :schema]
end
