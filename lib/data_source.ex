defmodule Etl.DataSource do
  @type config :: Etl.Config
  @type table  :: List

  @callback tables(config) :: any
  @callback pull(table, config) :: any
  @callback table_schema(table, config) :: any
end
