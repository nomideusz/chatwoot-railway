#!/bin/bash
set -e

# Runs once on first boot (empty PGDATA). Chatwoot's migrations also create
# the extension, but pre-creating removes any privilege surprises.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS vector;
EOSQL
