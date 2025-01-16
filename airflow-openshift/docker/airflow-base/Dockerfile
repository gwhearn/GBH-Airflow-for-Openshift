# Start with UBI8 minimal as base
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9

# Set labels for better maintainability
LABEL maintainer="GBH <gwhearn@gmail.com>"
LABEL description="Apache Airflow 2.10 on UBI8"
LABEL version="1.0.0"

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow
ENV AIRFLOW_VERSION=2.10.0
ENV PYTHON_VERSION=3.10
ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Create airflow user with specific UID/GID for OpenShift compatibility
ENV AIRFLOW_UID=1001
ENV AIRFLOW_GID=1001
RUN microdnf install -y shadow-utils && \
    groupadd -g ${AIRFLOW_GID} airflow && \
    useradd -u ${AIRFLOW_UID} -g ${AIRFLOW_GID} -d ${AIRFLOW_HOME} airflow

# Install required packages
RUN microdnf update -y && \
    microdnf install -y \
    python39 \
    python39-devel \
    gcc \
    gcc-c++ \
    git \
    wget \
    tar \
    gzip \
    libffi-devel \
    openssl-devel \
    bzip2-devel \
    sqlite-devel \
    xz-devel \
    which \
    procps \
    python3-pip \
    && microdnf clean all

# Create virtual environment
RUN python3.9 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Upgrade pip and install Airflow
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Create necessary directories
RUN mkdir -p ${AIRFLOW_HOME} && \
    mkdir -p ${AIRFLOW_HOME}/dags && \
    mkdir -p ${AIRFLOW_HOME}/logs && \
    mkdir -p ${AIRFLOW_HOME}/plugins && \
    mkdir -p ${AIRFLOW_HOME}/config

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set permissions for OpenShift
RUN chown -R airflow:airflow ${AIRFLOW_HOME} && \
    chmod -R g+rwx ${AIRFLOW_HOME} && \
    chown -R airflow:airflow ${VIRTUAL_ENV} && \
    chmod -R g+rwx ${VIRTUAL_ENV}

# Switch to airflow user
USER ${AIRFLOW_UID}
WORKDIR ${AIRFLOW_HOME}

# Expose port for webserver
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"] 