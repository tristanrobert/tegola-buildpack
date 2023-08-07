#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER tegola WITH PASSWORD 'tegola';
    CREATE DATABASE tegola;
    GRANT ALL PRIVILEGES ON DATABASE tegola TO tegola;
EOSQL