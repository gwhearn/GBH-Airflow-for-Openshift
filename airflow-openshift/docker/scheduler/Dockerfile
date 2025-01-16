# Use our base Airflow image
FROM gwhearn/airflow-ubi8:2.10.0

# Override labels
LABEL description="Apache Airflow 2.10 Scheduler"

# Switch to root for file operations
USER root

# Copy component-specific entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown airflow:airflow /entrypoint.sh

# Switch back to airflow user
USER ${AIRFLOW_UID}

# No need to expose ports for scheduler

ENTRYPOINT ["/entrypoint.sh"] 