#!/bin/bash
set -e

# Wait for database to be ready
airflow db check

# Start the triggerer
exec airflow triggerer 