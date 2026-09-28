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

# Recorre todos los CSV de customer.
for csv_file in subject/customer/*.csv; do
    # Usa el nombre del CSV, sin extensión, como nombre de tabla.
    table_name=$(basename "$csv_file" .csv)
    echo "Importando $table_name"

    # Borra la tabla anterior y crea una nueva con las seis columnas.
    docker compose -f ex00/docker-compose.yml exec -T postgres \
        psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
        -c "DROP TABLE IF EXISTS $table_name;
            CREATE TABLE $table_name (
                event_time TIMESTAMPTZ,
                event_type VARCHAR(16),
                product_id INTEGER,
                price NUMERIC,
                user_id BIGINT,
                user_session UUID
            );"

    # Importa las filas del CSV y omite la cabecera.
    docker compose -f ex00/docker-compose.yml exec -T postgres \
        psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
        -c "\copy $table_name FROM STDIN WITH (FORMAT csv, HEADER true)" \
        < "$csv_file"
done
