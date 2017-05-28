use Mix.Config

config(
  :etl,
  source: "test/fixtures/basic.csv",
  destination: "test/output/",
  source_adapter: Etl.FileSource,
  destination_adapter: Etl.FileSink
)
