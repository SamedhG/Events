#!/bin/bash
# deploy script adapted from class notes
export MIX_ENV=prod
export SECRET_KEY_BASE=insecure
export PORT=4820

mix deps.get --only prod
mix compile


KEY=`pwd`/cfg/.base

if [ ! -e "$KEY" ]; then
    mix phx.gen.secret > "$KEY"
fi

DB_PASS=`pwd/cfg/.db_pass`

if [ ! -e "$DB_PASS" ]; then
    pwgen 12 1 > "$DB_PASS"
fi

SECRET_KEY_BASE=$(cat "$KEY")
export SECRET_KEY_BASE
export DATABASE_URL=ecto://events_db:`cat $DB_PASS`/events



npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

mix release
