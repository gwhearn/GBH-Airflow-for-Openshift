# Use our custom Airflow base image
FROM gwhearn/airflow-ubi8:2.10.0

# Set environment variables
ENV AIRFLOW_COMPONENT=webserver \
    AIRFLOW_WWW_USER_USERNAME=admin \
    AIRFLOW_WWW_USER_PASSWORD=admin

# Create required directories
USER root
RUN mkdir -p /opt/airflow/logs/webserver && \
    chown -R airflow:airflow /opt/airflow/logs/webserver && \
    chmod -R g+w /opt/airflow/logs/webserver

# Switch back to airflow user
USER airflow

# Expose web UI port
EXPOSE 8080

# Command to run
CMD ["webserver"] 