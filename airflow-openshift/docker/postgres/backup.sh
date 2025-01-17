#!/bin/bash

# Configuration
BACKUP_DIR="/backup"
POSTGRES_DB="${POSTGRES_DB:-airflow}"
POSTGRES_USER="${POSTGRES_USER:-airflow}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
POSTGRES_HOST="${POSTGRES_HOST:-localhost}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"
RETENTION_DAYS=7

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamp for backup file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${POSTGRES_DB}_${TIMESTAMP}.sql.gz"

# Export database
echo "Starting backup of database: $POSTGRES_DB"
PGPASSWORD="$POSTGRES_PASSWORD" pg_dump \
    -h "$POSTGRES_HOST" \
    -p "$POSTGRES_PORT" \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -F p \
    -v \
    | gzip > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
    
    # Set appropriate permissions
    chmod 600 "$BACKUP_FILE"
    
    # Clean up old backups
    find "$BACKUP_DIR" -type f -name "${POSTGRES_DB}_*.sql.gz" -mtime +$RETENTION_DAYS -delete
    echo "Cleaned up backups older than $RETENTION_DAYS days"
else
    echo "Backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Create a symlink to latest backup
ln -sf "$BACKUP_FILE" "$BACKUP_DIR/latest.sql.gz"

exit 0 