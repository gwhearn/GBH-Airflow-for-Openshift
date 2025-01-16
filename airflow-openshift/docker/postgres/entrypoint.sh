#!/bin/bash
set -e

# Initialize PostgreSQL if data directory is empty
if [ -z "$(ls -A "$PGDATA")" ]; then
    echo "Initializing PostgreSQL database..."
    initdb --username="$POSTGRES_USER" --pwfile=<(echo "$POSTGRES_PASSWORD")

    # Modify postgresql.conf for better performance and logging
    cat >> "$PGDATA/postgresql.conf" << EOF
# Connection settings
listen_addresses = '*'
max_connections = 100

# Memory settings
shared_buffers = 128MB
work_mem = 4MB
maintenance_work_mem = 64MB

# Write ahead log settings
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB

# Query tuning
random_page_cost = 1.1
effective_cache_size = 512MB

# Logging settings
log_destination = 'stderr'
logging_collector = on
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_rotation_age = 1d
log_rotation_size = 100MB
log_min_duration_statement = 1000
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
EOF

    # Modify pg_hba.conf for secure connections
    cat > "$PGDATA/pg_hba.conf" << EOF
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all            all                                     trust
host    all            all             127.0.0.1/32           scram-sha-256
host    all            all             ::1/128                scram-sha-256
host    all            all             0.0.0.0/0              scram-sha-256
EOF

    # Start PostgreSQL temporarily to create user and database
    pg_ctl -D "$PGDATA" -o "-c listen_addresses=''" -w start

    # Create user and database
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname postgres << EOF
        CREATE DATABASE $POSTGRES_DB;
        GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
EOF

    # Run any additional initialization scripts
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sql)    echo "Running $f"; psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$f" ;;
            *.sql.gz) echo "Running $f"; gunzip -c "$f" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" ;;
            *)        echo "Ignoring $f" ;;
        esac
    done

    # Stop temporary server
    pg_ctl -D "$PGDATA" -m fast -w stop
fi

# Start PostgreSQL server
exec postgres -D "$PGDATA" 