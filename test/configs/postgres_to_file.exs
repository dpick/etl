use Mix.Config

config(
  :etl,
  source_adapter: Etl.PostgresSource,
  destination_adapter: Etl.FileSink,
  destination: "test/output",
  source_schema: "public",
  source_connection: [
    hostname: "localhost",
    database: "postgres",
    username: "postgres"
  ]
)
