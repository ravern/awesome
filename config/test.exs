use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :awesome, AwesomeWeb.Endpoint,
  http: [port: 4001],
  server: true # Wallaby

# Print only warnings and errors during test
config :logger, level: :warn

# SQL Sandbox for concurrent testing
config :awesome, sql_sandbox: true

# Reduce number of rounds when testing (save time)
config :bcrypt_elixir, log_rounds: 4

# Configure your database
config :awesome, Awesome.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "awesome_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
