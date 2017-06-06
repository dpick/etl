use Mix.Config

config(
  :etl,
  source_adapter: Etl.PostgresSource,
  destination_adapter: Etl.PostgresSink,
  destination: "test/output",
  source_schema: "public",
  destination_schema: "test",
  source_connection: [
    hostname: "localhost",
    database: "postgres",
    username: "postgres"
  ],
  destination_connection: [
    hostname: "localhost",
    database: "postgres",
    username: "postgres"
  ]
)
