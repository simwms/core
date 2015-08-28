# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :core, Core.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "tsZcfULea4LjJ8Dq17tJUj10pVCLCJQ/p5M6N9MPl44XQBXUla+MAgxokVAjrs2O",
  render_errors: [default_format: "html"],
  pubsub: [name: Core.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :gateway, Simwms,
  url: "http://localhost:4000",
  master_key: "koudou ga yamu made soba ni iru nante tagaeru yakusoku ha sezu tada anata to itai",
  uiux_host: "https://simwms.github.io/uiux",
  config_host: "https://simwms.github.io/config",
  namespace: "apiv3"

config :gateway, Amazon,
  access_key_id: "AKIAINYEM24JX5TX33LA",
  secret_access_key: "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"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
