use Mix.Config

config :etl,
  source_type: "postgres",
  destination_type: "file",
  destination: "test/output",
  schema: "public",
  connection: [
    hostname: "localhost",
    database: "postgres",
    username: "postgres"
  ]
