#!/bin/bash
set -e

CONTAINER="karhub-beer-postgresql"
DB_NAME="keycloak"
DB_USER="karhub"
DUMP_PATH="/dumps/keycloak_dump_20250830_1709.sql"

echo ">>> Resetando schema public do database '$DB_NAME' dentro do container $CONTAINER..."

docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME <<-EOSQL
    DROP SCHEMA IF EXISTS public CASCADE;
    CREATE SCHEMA public;
    GRANT ALL ON SCHEMA public TO $DB_USER;
    GRANT ALL ON SCHEMA public TO public;
EOSQL

echo ">>> Schema public recriado. Agora aplicando dump..."

docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME -f $DUMP_PATH

echo ">>> Dump aplicado com sucesso no database '$DB_NAME'."
