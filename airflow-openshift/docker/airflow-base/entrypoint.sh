#!/bin/bash

# Airflow needs to know who you are
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${AIRFLOW_USER:-default}:x:$(id -u):0:${AIRFLOW_USER:-default} user:${AIRFLOW_HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Initialize the database if needed
if [ "$1" = "webserver" ] || [ "$1" = "scheduler" ] || [ "$1" = "worker" ]; then
    airflow db check || airflow db init
fi

# Create admin user on webserver
if [ "$1" = "webserver" ]; then
    airflow users create \
        --username admin \
        --firstname admin \
        --lastname admin \
        --role Admin \
        --email admin@example.com \
        --password admin || true
fi

# Start the requested Airflow component
case "$1" in
  webserver)
    exec airflow webserver
    ;;
  scheduler)
    exec airflow scheduler
    ;;
  worker)
    exec airflow celery worker
    ;;
  flower)
    exec airflow celery flower
    ;;
  triggerer)
    exec airflow triggerer
    ;;
  version)
    exec airflow version
    ;;
  *)
    exec "$@"
    ;;
esac 