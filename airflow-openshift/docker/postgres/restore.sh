#!/bin/bash

# Configuration
BACKUP_DIR="/backup"
POSTGRES_DB="${POSTGRES_DB:-airflow}"
POSTGRES_USER="${POSTGRES_USER:-airflow}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
POSTGRES_HOST="${POSTGRES_HOST:-localhost}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

# Function to list available backups
list_backups() {
    echo "Available backups:"
    ls -lh "$BACKUP_DIR"/*.sql.gz 2>/dev/null || echo "No backups found"
}

# Function to restore from a backup file
restore_backup() {
    local backup_file=$1
    
    if [ ! -f "$backup_file" ]; then
        echo "Error: Backup file not found: $backup_file"
        exit 1
    fi
    
    echo "Starting restore of database: $POSTGRES_DB from $backup_file"
    
    # Drop existing connections
    PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$POSTGRES_HOST" \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "postgres" \
        -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$POSTGRES_DB' AND pid <> pg_backend_pid();"
    
    # Drop and recreate database
    PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$POSTGRES_HOST" \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "postgres" \
        -c "DROP DATABASE IF EXISTS $POSTGRES_DB;"
    
    PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$POSTGRES_HOST" \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "postgres" \
        -c "CREATE DATABASE $POSTGRES_DB;"
    
    # Restore from backup
    gunzip -c "$backup_file" | PGPASSWORD="$POSTGRES_PASSWORD" psql \
        -h "$POSTGRES_HOST" \
        -p "$POSTGRES_PORT" \
        -U "$POSTGRES_USER" \
        -d "$POSTGRES_DB" \
        -v ON_ERROR_STOP=1
    
    if [ $? -eq 0 ]; then
        echo "Restore completed successfully"
    else
        echo "Restore failed!"
        exit 1
    fi
}

# Main script logic
case "$1" in
    "list")
        list_backups
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <backup_file>"
            echo "Or use: $0 restore latest (to restore from latest backup)"
            exit 1
        fi
        
        if [ "$2" = "latest" ]; then
            BACKUP_FILE="$BACKUP_DIR/latest.sql.gz"
        else
            BACKUP_FILE="$2"
        fi
        
        restore_backup "$BACKUP_FILE"
        ;;
    *)
        echo "Usage: $0 {list|restore} [backup_file]"
        echo "Examples:"
        echo "  $0 list                    # List available backups"
        echo "  $0 restore latest          # Restore from latest backup"
        echo "  $0 restore /path/to/backup # Restore from specific backup"
        exit 1
        ;;
esac

exit 0 