#!/bin/bash
# deploy script adapted from class notes
export MIX_ENV=prod
export SECRET_KEY_BASE=insecure
export PORT=4820
DB_PASS=`pwd/cfg/.db_pass`

if [ ! -e "$DB_PASS" ]; then
    echo "Setup the database first"
    exit 1
fi

export DATABASE_URL=ecto://events_db:`cat $DB_PASS`/events

mix deps.get --only prod
mix compile


KEY=`pwd`/cfg/.base

if [ ! -e "$KEY" ]; then
    mix phx.gen.secret > "$KEY"
fi



SECRET_KEY_BASE=$(cat "$KEY")
export SECRET_KEY_BASE



npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

mix release
