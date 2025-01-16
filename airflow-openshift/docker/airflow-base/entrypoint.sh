#!/bin/bash
set -e

# Initialize airflow database
airflow db init

# Create admin user if not exists
airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email admin@example.com \
    --password admin \
    || true

# Start airflow webserver
exec airflow webserver 