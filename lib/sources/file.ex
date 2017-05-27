defmodule Etl.FileSource do
  @behaviour Etl.DataSource

  def pull(location) do
    File.stream!(location)
  end
end
