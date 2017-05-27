defmodule Etl.FileSource do
  @behaviour Etl.DataSource

  def tables(config) do
    name = config.source
    |> String.split("/")
    |> List.last
    |> String.split(".")
    |> List.first

    [name]
  end

  def pull(_, config) do
    File.stream!(config.source)
  end
end
