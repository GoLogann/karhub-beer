#!/bin/bash
set -e
echo ">>> Criando database keycloak..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE keycloak;
EOSQL
echo ">>> Database keycloak criado com sucesso!"
