#!/bin/bash
set -e

# Initialize PostgreSQL if data directory is empty
if [ -z "$(ls -A "$PGDATA")" ]; then
    echo "Initializing PostgreSQL database..."
    initdb --username="$POSTGRES_USER" --pwfile=<(echo "$POSTGRES_PASSWORD")

    # Update postgresql.conf
    {
        echo "listen_addresses = '*'"
        echo "max_connections = 100"
        echo "shared_buffers = 128MB"
        echo "dynamic_shared_memory_type = posix"
        echo "log_destination = 'stderr'"
        echo "logging_collector = on"
        echo "log_directory = '/var/log/postgresql'"
        echo "log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'"
        echo "log_rotation_age = 1d"
        echo "log_rotation_size = 10MB"
    } >> "$PGDATA/postgresql.conf"

    # Update pg_hba.conf for password authentication
    {
        echo "host all all all md5"
    } >> "$PGDATA/pg_hba.conf"

    # Start PostgreSQL temporarily to create user and database
    pg_ctl -D "$PGDATA" -o "-c listen_addresses='localhost'" -w start

    # Create user and database
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres <<-EOSQL
        CREATE DATABASE $POSTGRES_DB;
        GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOSQL

    # Stop PostgreSQL
    pg_ctl -D "$PGDATA" -m fast -w stop
fi

# Run any initialization scripts
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh)  echo "$0: running $f"; . "$f" ;;
        *.sql) echo "$0: running $f"; psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$f";;
        *)     echo "$0: ignoring $f" ;;
    esac
done

# Start PostgreSQL
exec postgres 