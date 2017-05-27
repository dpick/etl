defmodule Etl.FileSink do
  @behaviour Etl.DataSink

  def push(data, config, table) do
    file = File.stream!(output_path(config, table))

    data |> Enum.into(file)
  end

  def output_path(config, table) do
    if String.ends_with?(config.destination, "/") do
      config.destination <> table <> ".csv"
    else
      config.destination <> "/" <> table <> ".csv"
    end
  end
end
