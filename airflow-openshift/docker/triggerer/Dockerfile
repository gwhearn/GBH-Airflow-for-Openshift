# Use our custom Airflow base image
FROM gwhearn/airflow-ubi8:2.10.0

# Set environment variables
ENV AIRFLOW_COMPONENT=triggerer

# Create required directories
USER root
RUN mkdir -p /opt/airflow/logs/triggerer && \
    chown -R airflow:airflow /opt/airflow/logs/triggerer && \
    chmod -R g+w /opt/airflow/logs/triggerer

# Switch back to airflow user
USER airflow

# Command to run
CMD ["triggerer"] 