#!/bin/bash
set -e

# Generate random password if not provided
if [ -z "$REDIS_PASSWORD" ]; then
    export REDIS_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
    echo "Generated random Redis password: $REDIS_PASSWORD"
fi

# Replace password in config
sed -i "s/\${REDIS_PASSWORD}/$REDIS_PASSWORD/" ${REDIS_CONF_DIR}/redis.conf

# Start Redis server
exec redis-server ${REDIS_CONF_DIR}/redis.conf 