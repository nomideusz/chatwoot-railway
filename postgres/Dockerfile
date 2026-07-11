# pgvector image — Chatwoot v4 requires the vector extension (Captain AI).
# Matches upstream docker-compose.production.yaml exactly.
FROM pgvector/pgvector:pg16

# PGDATA one level below the mount: Railway volumes arrive with lost+found,
# which initdb refuses to initialize into.
ENV POSTGRES_USER=postgres \
    POSTGRES_DB=chatwoot \
    PGDATA=/var/lib/postgresql/data/pgdata

COPY init-pgvector.sh /docker-entrypoint-initdb.d/init-pgvector.sh
