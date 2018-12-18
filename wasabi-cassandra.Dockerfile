FROM cassandra:3.11.3

WORKDIR /wasabi

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

ARG WASABI_VERSION
RUN git clone --depth 1 https://github.com/intuit/wasabi.git . --branch ${WASABI_VERSION}
RUN mkdir -p /wasabi/migrations \
    && cp -R /wasabi/modules/repository-datastax/src/main/resources/com/intuit/wasabi/repository/impl/cassandra/migration /wasabi/migrations

ADD https://github.com/hhandoko/cassandra-migration/releases/download/cassandra-migration-0.15/cassandra-migration-0.15-jar-with-dependencies.jar .
ADD cassandra-setup.sh .

ARG CASSANDRA_HOST=localhost
ARG CASSANDRA_KEYSPACE_PREFIX=wasabi
ARG CASSANDRA_PASSWORD
ARG CASSANDRA_PORT=9042
ARG CASSANDRA_REPLICATION=1
ARG CASSANDRA_USER

ENV CASSANDRA_MIGRATION_DIR=/wasabi/migrations \
    CASSANDRA_MIGRATION_JAR=/wasabi/cassandra-migration-0.15-jar-with-dependencies.jar \
    CASSANDRA_USER=${CASSANDRA_USER} \
    CASSANDRA_HOST=${CASSANDRA_HOST} \
    CASSANDRA_KEYSPACE_PREFIX=${CASSANDRA_KEYSPACE_PREFIX} \
    CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD} \
    CASSANDRA_PORT=${CASSANDRA_PORT} \
    CASSANDRA_REPLICATION=${CASSANDRA_REPLICATION}

CMD ["sh", "/wasabi/cassandra-setup.sh"]
