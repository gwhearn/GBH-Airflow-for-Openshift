#!/bin/bash
set -e

# Create auth_file with proper md5 passwords
if [ ! -f /etc/pgbouncer/userlist.txt ]; then
    echo "\"$PGBOUNCER_USER\" \"$(echo -n "$PGBOUNCER_PASSWORD" | md5sum | cut -d' ' -f1)\"" > /etc/pgbouncer/userlist.txt
    echo "\"$DB_USER\" \"$(echo -n "$DB_PASSWORD" | md5sum | cut -d' ' -f1)\"" >> /etc/pgbouncer/userlist.txt
fi

# Start PgBouncer
exec pgbouncer /etc/pgbouncer/pgbouncer.ini 