# Use UBI8 minimal as base
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9

# Set labels
LABEL maintainer="GBH <gwhearn@gmail.com>"
LABEL description="Redis server for Airflow Celery broker"
LABEL version="1.0.0"

# Set environment variables
ENV REDIS_VERSION=7.2.4
ENV REDIS_USER=redis
ENV REDIS_DATA_DIR=/data
ENV REDIS_CONF_DIR=/etc/redis

# Create redis user with specific UID/GID for OpenShift compatibility
ENV REDIS_UID=1003
ENV REDIS_GID=1003
RUN microdnf install -y shadow-utils && \
    groupadd -g ${REDIS_GID} redis && \
    useradd -u ${REDIS_UID} -g ${REDIS_GID} -d ${REDIS_DATA_DIR} redis

# Install build dependencies
RUN microdnf install -y \
    gcc \
    make \
    wget \
    tar \
    gzip \
    procps-ng \
    && microdnf clean all

# Download and install Redis
WORKDIR /tmp
RUN wget https://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz && \
    tar xzf redis-${REDIS_VERSION}.tar.gz && \
    cd redis-${REDIS_VERSION} && \
    make MALLOC=libc && \
    make install && \
    cd .. && \
    rm -rf redis-${REDIS_VERSION}*

# Create necessary directories
RUN mkdir -p ${REDIS_DATA_DIR} && \
    mkdir -p ${REDIS_CONF_DIR} && \
    mkdir -p /var/log/redis

# Copy configuration files
COPY redis.conf ${REDIS_CONF_DIR}/
COPY entrypoint.sh /usr/local/bin/

# Set permissions
RUN chown -R redis:redis ${REDIS_DATA_DIR} && \
    chmod -R 0750 ${REDIS_DATA_DIR} && \
    chown -R redis:redis ${REDIS_CONF_DIR} && \
    chmod -R 0750 ${REDIS_CONF_DIR} && \
    chown -R redis:redis /var/log/redis && \
    chmod -R 0750 /var/log/redis && \
    chmod +x /usr/local/bin/entrypoint.sh

# Switch to redis user
USER ${REDIS_UID}

# Create volume mount points
VOLUME ["${REDIS_DATA_DIR}", "/var/log/redis"]

# Expose Redis port
EXPOSE 6379

# Set entrypoint
ENTRYPOINT ["entrypoint.sh"] 