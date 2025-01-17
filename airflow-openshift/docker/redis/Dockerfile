FROM redis:7.2

# Set environment variables
ENV REDIS_PORT=6379

# Switch to root to modify filesystem
USER root

# Create redis user with specific UID/GID for OpenShift compatibility
RUN groupmod -g 1001 redis && \
    usermod -u 1001 -g 1001 redis && \
    mkdir -p /data /var/log/redis && \
    chown -R 1001:1001 /data /var/log/redis && \
    chmod -R 0700 /data /var/log/redis && \
    chmod g=u /etc/passwd /etc/group

# Copy configuration files
COPY redis.conf /usr/local/etc/redis/redis.conf

# Set permissions for config files
RUN chown 1001:1001 /usr/local/etc/redis/redis.conf && \
    chmod 0600 /usr/local/etc/redis/redis.conf

# Switch back to redis user
USER 1001

# Create volume mount points
VOLUME ["/data", "/var/log/redis"]

# Expose Redis port
EXPOSE 6379

# Set default command
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"] 