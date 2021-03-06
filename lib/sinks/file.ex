defmodule Etl.FileSink do
  @behaviour Etl.DataSink

  def push(data, config, table) do
    file = File.open!(Etl.DataSink.output_path(config, table), [:write, :utf8])

    data |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end

  def table_schema(table, config) do
  end

  def recreate_schema(table, config, source_schema) do
  end

  def output_path(config, table) do
    if String.ends_with?(config.destination, "/") do
      config.destination <> table <> ".csv"
    else
      config.destination <> "/" <> table <> ".csv"
    end
  end
end
