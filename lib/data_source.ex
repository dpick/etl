defmodule Etl.DataSource do
  @type config :: Etl.Config
  @type tables :: List

  @callback tables(config) :: any
  @callback pull(tables, config) :: any
end
