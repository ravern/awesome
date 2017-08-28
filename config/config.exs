# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :awesome,
  ecto_repos: [Awesome.Repo]

# Configures the endpoint
config :awesome, AwesomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2btR3Eg61bKlvaAs0tDvTB6PJdjQ1aoaZbY1VRB2oRaW0nrQkFo5cFh2ammCeINw",
  render_errors: [view: AwesomeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Awesome.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Authentication
config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      param_nesting: "user",
      scrub_params: false,
    ]}
  ]

# Guardian JWT stuff
config :guardian, Guardian,
  issuer: "Awesome <awesome-lists>",
  ttl: { 30, :days },
  allowed_drift: 2000,
  secret_key: "SdD7W4FlBEBJIsNGNyYfGWhvfqaeRVsCJhmHmBhiwIJANps4Ed9l29qg8gV2zWji",
  serializer: Awesome.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
