defmodule Etl.FileSink do
  @behaviour Etl.DataSink

  def push(data, location) do
    file = File.stream!(location)

    data |> Enum.into(file)
  end
end
