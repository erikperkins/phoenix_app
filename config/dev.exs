use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :bayberry, BayberryWeb.Endpoint,
  http: [port: 8000, acceptors: 50],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Configure external API endpoints
config :bayberry, BayberryWeb.Endpoint,
  mnist: "http://mnist.datapun.net/mnist",
  nlp: "http://main.datapun.net:1025/lda",
  timeseries: "http://timeseries.datapun.net/api/forecast",
  rabbitmq: "localhost",
  redis: "localhost"

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :bayberry, BayberryWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/bayberry_web/views/.*(ex)$},
      ~r{lib/bayberry_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :bayberry, Bayberry.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "development",
  password: "development",
  database: "development",
  hostname: "localhost",
  pool_size: 10

config :bayberry, Bayberry.Geolocation,
  adapter: Ecto.Adapters.Postgres,
  username: "development",
  password: "development",
  database: "geolocation",
  hostname: "localhost",
  pool_size: 5

config :bayberry, BayberryWeb.Plugs,
  authorization: BayberryWeb.Plugs.Authorization,
  geolocation: BayberryWeb.Plugs.Geolocation
