# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :notify,
  ecto_repos: [Notify.Repo],
  mail_from: "NOTIFY SENDER <notify@xxxx.xx>",
  mail_to: "to@xxxx.xx"

# Configures the endpoint
config :notify, Notify.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "i5bB4LhUfwbj1dmKqHHKg06pHjwTqZE+K0TlPvRQByZTFqwWn3vtFEtxNFbYpWWa",
  render_errors: [view: Notify.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Notify.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
