# Use our base Airflow image
FROM gwhearn/airflow-ubi8:2.10.0

# Override labels
LABEL description="Apache Airflow 2.10 Celery Worker"

# Switch to root for installations and file operations
USER root

# Install additional dependencies for Celery
RUN pip install --no-cache-dir \
    apache-airflow[celery] \
    redis

# Copy component-specific entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown airflow:airflow /entrypoint.sh

# Switch back to airflow user
USER ${AIRFLOW_UID}

# No need to expose ports for worker

ENTRYPOINT ["/entrypoint.sh"] 