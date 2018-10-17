#!/bin/bash
mix ecto.setup
mix run priv/repo/seeds.exs
cd assets
npm rebuild node-sass
node node_modules/brunch/bin/brunch build --production
cd ..
mix phx.digest
exec "$@"
