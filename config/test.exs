use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :core, Core.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :core, Core.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "core_test",
  pool: Ecto.Adapters.SQL.Sandbox, # Use a sandbox for transactional testing
  size: 1
