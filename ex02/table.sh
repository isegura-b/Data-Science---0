#!/bin/bash
set -e

cd "$(dirname "$0")/.."

if [ ! -f ex00/.env ]; then
  echo "Error: copia ex00/.env.example a ex00/.env y configura las credenciales." >&2
  exit 1
fi

set -a
. ./ex00/.env
set +a

# Recrea la tabla ejecutando table.sql.
docker compose -f ex00/docker-compose.yml exec -T postgres \
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" < ex02/table.sql

# Importa las filas del CSV sin incluir la cabecera.
docker compose -f ex00/docker-compose.yml exec -T postgres \
  psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -c "\copy data_2022_oct FROM STDIN WITH (FORMAT csv, HEADER true)" \
  < subject/customer/data_2022_oct.csv
