defmodule Etl.FileSink do
  @behaviour Etl.DataSink

  def push(data, config, table) do
    file = File.open!(Etl.DataSink.output_path(config, table), [:write, :utf8])

    data |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end
end
