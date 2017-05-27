defprotocol Etl.DataSource do
  def empty?(data)
end

defimpl Etl.DataSource, for: Etl.Config do
  def data(%{source: %{type: :file}} = config) do
    File.stream!(config[:source][:location])
  end
end
