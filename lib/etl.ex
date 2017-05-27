defmodule Etl do
  @moduledoc """
  Documentation for Etl.
  """

  def run(input_file, output_file) do
    input_file
    |> Etl.FileSource.pull
    |> Etl.FileSink.push(output_file)
  end
end
