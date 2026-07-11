FROM redis:7-alpine

# No config file → redis binds all interfaces including IPv6 (required on
# Railway's private network). requirepass matches upstream compose.
# appendonly on a small volume: queued Sidekiq jobs survive restarts.
CMD ["sh", "-c", "redis-server --appendonly yes --requirepass \"$REDIS_PASSWORD\""]
