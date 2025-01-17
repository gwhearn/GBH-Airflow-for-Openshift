#!/bin/bash

# Configuration
LOG_DIR="/opt/airflow/logs"
MAX_SIZE="100M"
ROTATE_COUNT=5
COMPRESS=true

# Function to check file size
check_size() {
    local file=$1
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local max_bytes=$(numfmt --from=iec $MAX_SIZE)
    
    if [ $size -gt $max_bytes ]; then
        return 0
    else
        return 1
    fi
}

# Function to rotate a single file
rotate_file() {
    local file=$1
    
    # Remove oldest rotation if it exists
    if [ -f "${file}.${ROTATE_COUNT}.gz" ]; then
        rm "${file}.${ROTATE_COUNT}.gz"
    fi
    
    # Rotate existing backups
    for i in $(seq $((ROTATE_COUNT-1)) -1 1); do
        if [ -f "${file}.$i.gz" ]; then
            mv "${file}.$i.gz" "${file}.$((i+1)).gz"
        fi
    done
    
    # Rotate current file
    if [ -f "$file" ]; then
        cp "$file" "${file}.1"
        truncate -s 0 "$file"
        if [ "$COMPRESS" = true ]; then
            gzip "${file}.1"
        fi
    fi
}

# Main rotation logic
find "$LOG_DIR" -type f -name "*.log" | while read -r log_file; do
    if check_size "$log_file"; then
        rotate_file "$log_file"
        echo "Rotated: $log_file"
    fi
done

# Clean up old rotated logs (older than 30 days)
find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -delete

exit 0 