# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# General application configuration
config :bayberry,
  ecto_repos: [Bayberry.Repo]

# Configures the endpoint
config :bayberry, BayberryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "848jxxJwuXulhXM078YPNoxL1QVyz2KrRI5sdByOkiEm5o8x05UEdqTWy9wHUqhT",
  render_errors: [view: BayberryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bayberry.PubSub, adapter: Phoenix.PubSub.PG2]

config :bayberry, BayberryWeb.Plugs,
  authorization: BayberryWeb.Plugs.Authorization,
  geolocation: BayberryWeb.Plugs.Geolocation

# Configure Elixir's Logger
config :logger, :console,
  format: {Bayberry.LogFormatter, :format},
  metadata: [:request_id]

# Configure Cross-Origin Resource Sharing
config :cors_plug,
  origin: "*",
  max_age: 86400,
  methods: ["GET", "POST"]

config :hound,
  driver: "phantomjs",
  browser: "firefox"

# Configure external API endpoints
config :bayberry, :data_punnet,
  mnist: System.get_env("MNIST_ENDPOINT"),
  lda: System.get_env("LDA_ENDPOINT"),
  timeseries: System.get_env("TIMESERIES_ENDPOINT")

# Configure MNIST API parameters
config :bayberry, :mnist,
  threads: System.get_env("MNIST_THREADS")

config :bayberry, :rabbitmq,
  host: System.get_env("RABBITMQ_HOST"),
  username: System.get_env("RABBITMQ_USERNAME"),
  password: System.get_env("RABBITMQ_PASSWORD"),
  message_ttl: System.get_env("RABBITMQ_MESSAGE_TTL")

config :bayberry, :redis,
  host: System.get_env("REDIS_HOST"),
  database: System.get_env("REDIS_DATABASE"),
  password: System.get_env("REDIS_PASSWORD")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
