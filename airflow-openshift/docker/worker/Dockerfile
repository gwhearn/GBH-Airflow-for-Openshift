# Use our custom Airflow base image
FROM gwhearn/airflow-ubi8:2.10.0

# Set environment variables
ENV AIRFLOW_COMPONENT=worker

# Create required directories
USER root
RUN mkdir -p /opt/airflow/logs/worker && \
    chown -R airflow:airflow /opt/airflow/logs/worker && \
    chmod -R g+w /opt/airflow/logs/worker

# Switch back to airflow user
USER airflow

# Expose Celery flower port
EXPOSE 5555

# Command to run
CMD ["celery", "worker"] 