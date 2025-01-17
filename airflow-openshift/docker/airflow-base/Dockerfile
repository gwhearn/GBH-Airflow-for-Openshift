FROM python:3.11-slim-bookworm

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow \
    AIRFLOW_VERSION=2.10.0 \
    PYTHON_VERSION=3.11 \
    CONSTRAINT_URL=https://raw.githubusercontent.com/apache/airflow/constraints-2.10.0/constraints-3.11.txt

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    default-libmysqlclient-dev \
    freetds-bin \
    freetds-dev \
    git \
    gosu \
    libffi-dev \
    libkrb5-dev \
    libpq-dev \
    libsasl2-2 \
    libsasl2-dev \
    libsasl2-modules \
    libssl-dev \
    locales \
    lsb-release \
    sasl2-bin \
    sqlite3 \
    unixodbc \
    unixodbc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create airflow user
RUN groupadd -g 1001 airflow && \
    useradd -u 1001 -g 1001 -d /opt/airflow airflow

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" -r requirements.txt --constraint "${CONSTRAINT_URL}"

# Copy configuration files
COPY airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY entrypoint.sh /entrypoint.sh
COPY webserver_config.py ${AIRFLOW_HOME}/webserver_config.py

# Set permissions for config files
RUN chown -R airflow:airflow ${AIRFLOW_HOME} && \
    chmod -R g+w ${AIRFLOW_HOME} && \
    chmod +x /entrypoint.sh

# Switch to airflow user
USER airflow
WORKDIR ${AIRFLOW_HOME}

# Expose ports
EXPOSE 8080

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 