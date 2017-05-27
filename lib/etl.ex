defmodule Etl do
  @moduledoc """
  Documentation for Etl.
  """

  def run(config) do
    source = "Elixir.Etl.#{String.capitalize(config.source_type)}Source" |> String.to_atom
    sink   = "Elixir.Etl.#{String.capitalize(config.destination_type)}Sink"   |> String.to_atom

    tables = apply(source, :tables, [config])

    Enum.each(tables, fn(table) ->
      data = apply(source, :pull, [table, config])
      apply(sink, :push, [data, config, table])
    end)
  end
end
