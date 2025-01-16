#!/bin/bash
set -e

# Wait for database to be ready
airflow db check

# Upgrade the database schema
airflow db upgrade

# Start the scheduler
exec airflow scheduler 