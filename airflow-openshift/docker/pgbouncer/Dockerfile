FROM postgres:15.5

# Set environment variables
ENV PGBOUNCER_USER=pgbouncer \
    PGBOUNCER_PASSWORD=pgbouncer \
    PGBOUNCER_DATABASE=postgres \
    PGBOUNCER_PORT=6432 \
    POSTGRESQL_HOST=postgres \
    POSTGRESQL_PORT=5432

# Switch to root to modify filesystem
USER root

# Install PgBouncer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pgbouncer \
    && rm -rf /var/lib/apt/lists/*

# Create pgbouncer user with specific UID/GID for OpenShift compatibility
RUN usermod -u 1001 postgres && \
    groupmod -g 1001 postgres && \
    mkdir -p /var/log/pgbouncer /var/run/pgbouncer /etc/pgbouncer && \
    chown -R 1001:1001 /var/log/pgbouncer /var/run/pgbouncer /etc/pgbouncer && \
    chmod -R 0700 /var/log/pgbouncer /var/run/pgbouncer /etc/pgbouncer && \
    chmod g=u /etc/passwd /etc/group

# Copy configuration files
COPY pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY userlist.txt /etc/pgbouncer/userlist.txt

# Set permissions for config files
RUN chown 1001:1001 /etc/pgbouncer/pgbouncer.ini /etc/pgbouncer/userlist.txt && \
    chmod 0600 /etc/pgbouncer/pgbouncer.ini /etc/pgbouncer/userlist.txt

# Switch back to postgres user
USER 1001

# Expose PgBouncer port
EXPOSE 6432

# Set default command
CMD ["pgbouncer", "/etc/pgbouncer/pgbouncer.ini"] 