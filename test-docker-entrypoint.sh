#!/bin/sh
set -e

echo "Environment: $RAILS_ENV"

bundle check || bundle install

bundle exec ${@}
