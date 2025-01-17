# Use our custom Airflow base image
FROM gwhearn/airflow-ubi8:2.10.0

# Set environment variables
ENV AIRFLOW_COMPONENT=scheduler

# Create required directories
USER root
RUN mkdir -p /opt/airflow/logs/scheduler && \
    chown -R airflow:airflow /opt/airflow/logs/scheduler && \
    chmod -R g+w /opt/airflow/logs/scheduler

# Switch back to airflow user
USER airflow

# Command to run
CMD ["scheduler"] 