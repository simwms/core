use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :core, Core.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "lit-atoll-7843.herokuapp.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section, and set your `:url` port to 443
#
#  config :core, Core.Endpoint,
#    ...
#    url: [host: "example.com", port: 443],
#    https: [port: 443,
#            keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#            certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

# Do not print debug messages in production
config :logger, level: :info

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :core, Core.Endpoint, server: true
#

config :core, Core.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database, trivial change to trigger rebuild
config :core, Core.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20 # The amount of database connections in the pool
