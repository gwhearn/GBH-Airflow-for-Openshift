# Use UBI8 minimal as base
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.9

# Set labels
LABEL maintainer="GBH <gwhearn@gmail.com>"
LABEL description="PgBouncer connection pooler for PostgreSQL"
LABEL version="1.0.0"

# Set environment variables
ENV PGBOUNCER_VERSION=1.20.1
ENV PGBOUNCER_USER=pgbouncer
ENV PGBOUNCER_PASSWORD=pgbouncer

# Create pgbouncer user with specific UID/GID for OpenShift compatibility
ENV PGBOUNCER_UID=1002
ENV PGBOUNCER_GID=1002
RUN microdnf install -y shadow-utils && \
    groupadd -g ${PGBOUNCER_GID} pgbouncer && \
    useradd -u ${PGBOUNCER_UID} -g ${PGBOUNCER_GID} -d /var/run/pgbouncer pgbouncer

# Install build dependencies
RUN microdnf install -y \
    gcc \
    make \
    pkgconfig \
    libevent-devel \
    openssl-devel \
    wget \
    tar \
    gzip \
    && microdnf clean all

# Download and install PgBouncer
WORKDIR /tmp
RUN wget https://www.pgbouncer.org/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz && \
    tar xvf pgbouncer-${PGBOUNCER_VERSION}.tar.gz && \
    cd pgbouncer-${PGBOUNCER_VERSION} && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && \
    rm -rf pgbouncer-${PGBOUNCER_VERSION}*

# Create necessary directories
RUN mkdir -p /etc/pgbouncer && \
    mkdir -p /var/log/pgbouncer && \
    mkdir -p /var/run/pgbouncer && \
    chown -R pgbouncer:pgbouncer /etc/pgbouncer && \
    chown -R pgbouncer:pgbouncer /var/log/pgbouncer && \
    chown -R pgbouncer:pgbouncer /var/run/pgbouncer && \
    chmod -R 700 /var/run/pgbouncer

# Copy configuration files
COPY pgbouncer.ini /etc/pgbouncer/
COPY userlist.txt /etc/pgbouncer/
RUN chown pgbouncer:pgbouncer /etc/pgbouncer/pgbouncer.ini && \
    chown pgbouncer:pgbouncer /etc/pgbouncer/userlist.txt && \
    chmod 644 /etc/pgbouncer/pgbouncer.ini && \
    chmod 644 /etc/pgbouncer/userlist.txt

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chown pgbouncer:pgbouncer /usr/local/bin/entrypoint.sh

# Switch to pgbouncer user
USER ${PGBOUNCER_UID}

# Create volume mount points
VOLUME ["/var/log/pgbouncer"]

# Expose PgBouncer port
EXPOSE 6432

# Set entrypoint
ENTRYPOINT ["entrypoint.sh"] 