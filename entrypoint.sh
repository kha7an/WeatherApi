#!/bin/bash
set -e
bundle install
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup
exec "$@"
