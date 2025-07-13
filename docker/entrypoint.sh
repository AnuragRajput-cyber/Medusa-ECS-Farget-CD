#!/bin/sh

# Wait for PostgreSQL to be available
until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
  echo "Waiting for PostgreSQL to be available..."
  sleep 2
done

# Run database migrations
medusa migrations run

# Start Medusa
medusa start