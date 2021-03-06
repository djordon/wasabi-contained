#!/usr/bin/env sh

cqlsh -e "\
    CREATE KEYSPACE IF NOT EXISTS ${CASSANDRA_KEYSPACE_PREFIX}_experiments
    WITH replication = {'class' : 'SimpleStrategy', 'replication_factor' : ${CASSANDRA_REPLICATION}};"\
    --username=${CASSANDRA_USER} \
    --password="${CASSANDRA_PASSWORD}" \
    ${CASSANDRA_HOST} \
    ${CASSANDRA_PORT}

java -jar -Dcassandra.migration.keyspace.name=${CASSANDRA_KEYSPACE_PREFIX}_experiments \
    -Dcassandra.migration.cluster.port=${CASSANDRA_PORT} \
    -Dcassandra.migration.cluster.username=${CASSANDRA_USER} \
    -Dcassandra.migration.cluster.password=${CASSANDRA_PASSWORD} \
    -Dcassandra.migration.scripts.locations=filesystem:${CASSANDRA_MIGRATION_DIR}\
    -Dcassandra.migration.cluster.contactpoints=${CASSANDRA_HOST} \
    ${CASSANDRA_MIGRATION_JAR} migrate

if [ $? -ne 0 ]; then
    echo "failed to execute the migration script. Please contact administrator."
    exit 1;
fi
