FROM postgres:15.5

# Set environment variables
ENV POSTGRES_USER=postgres \
    POSTGRES_PASSWORD=postgres \
    POSTGRES_DB=postgres

# Switch to root to modify filesystem
USER root

# Install additional utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Create postgres user with specific UID/GID for OpenShift compatibility
RUN usermod -u 1001 postgres && \
    groupmod -g 1001 postgres

# Create necessary directories with correct permissions
RUN mkdir -p /var/lib/postgresql/data /var/run/postgresql /var/log/postgresql && \
    chown -R 1001:1001 /var/lib/postgresql /var/run/postgresql /var/log/postgresql && \
    chmod -R 0700 /var/lib/postgresql/data /var/run/postgresql /var/log/postgresql && \
    chmod g=u /etc/passwd /etc/group

# Copy configuration files
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# Set permissions for config files
RUN chown 1001:1001 /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf && \
    chmod 0600 /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf

# Switch back to postgres user
USER 1001

# Expose PostgreSQL port
EXPOSE 5432

# Set default command
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"] 