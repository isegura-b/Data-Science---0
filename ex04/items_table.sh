#!/bin/bash
set -e

# Sitúa el script en la raíz del repositorio.
cd "$(dirname "$0")/.."

if [ ! -f ex00/.env ]; then
    echo "Error: copia ex00/.env.example a ex00/.env y configura las credenciales." >&2
    exit 1
fi

set -a
. ./ex00/.env
set +a

# Recrea la tabla items.
docker compose -f ex00/docker-compose.yml exec -T postgres \
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" < ex04/items_table.sql

# Importa item.csv sin incluir la cabecera.
docker compose -f ex00/docker-compose.yml exec -T postgres \
    psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
    -c "\copy items FROM STDIN WITH (FORMAT csv, HEADER true)" \
    < subject/item/item.csv
