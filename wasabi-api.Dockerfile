ARG WASABI_BASE_IMAGE
FROM ${WASABI_BASE_IMAGE} AS base

FROM openjdk:8u181-jre-slim-stretch

WORKDIR /app
RUN mkdir -p /app/logs

ARG CASSANDRA_USER
ARG CASSANDRA_PASSWORD
ARG CASSANDRA_HOST

ARG MYSQL_DATABASE
ARG MYSQL_HOSTNAME
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_PORT

ARG WASABI_PORT_API=8080
ARG WASABI_PORT_JMX=8090
ARG WASABI_PORT_DEBUG=8180
ARG WASABI_PROFILE=development
ARG WASABI_VERSION=1.0.20181205072204

ENV CASSANDRA_HOST=${CASSANDRA_HOST} \
    CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD} \
    CASSANDRA_USER=${CASSANDRA_USER} \
    MYSQL_DATABASE=${MYSQL_DATABASE} \
    MYSQL_HOSTNAME=${MYSQL_HOSTNAME} \
    MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    MYSQL_PORT=${MYSQL_PORT} \
    MYSQL_USER=${MYSQL_USER} \
    WASABI_PORT_API=${WASABI_PORT_API} \
    WASABI_PORT_JMX=${WASABI_PORT_JMX} \
    WASABI_PORT_DEBUG=${WASABI_PORT_DEBUG} \
    WASABI_PROFILE=${WASABI_PROFILE} \
    WASABI_TARGET_PATH=/app/modules/main/target \
    WASABI_VERSION=${WASABI_VERSION}

ARG WASABI_API_JAVA_OPTIONS="\
  -Xms256m\
  -Xmx256m\
  -server\
  -XX:+HeapDumpOnOutOfMemoryError\
  -XX:HeapDumpPath=/app/logs/java_1.hprof\
  -XX:+PrintGCApplicationStoppedTime\
  -XX:+PrintGCApplicationConcurrentTime\
  -XX:+PrintGCDetails\
  -XX:+PrintGCTimeStamps\
  -XX:+PrintTenuringDistribution\
  -XX:+UseConcMarkSweepGC\
  -XX:+UseParNewGC\
  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${WASABI_PORT_DEBUG}\
  -Djava.rmi.server.hostname=${HOSTNAME}\
  -Dcom.sun.management.jmxremote=true\
  -Dcom.sun.management.jmxremote.port=${WASABI_PORT_JMX}\
  -Dcom.sun.management.jmxremote.ssl=false\
  -Dcom.sun.management.jmxremote.authenticate=false\
  -Dlogback.configurationFile=/app/conf/logback.xml\
  -Djava.util.logging.config.file=/app/conf/logging.properties\
  -Ddatabase.url.host=${MYSQL_HOSTNAME}\
  -Ddatabase.url.port=${MYSQL_PORT}\
  -Ddatabase.url.dbname=${MYSQL_DATABASE}\
  -Ddatabase.user=${MYSQL_USER}\
  -Ddatabase.password=${MYSQL_PASSWORD}\
  -Dusername=${CASSANDRA_USER}\
  -Dpassword=${CASSANDRA_PASSWORD}\
  -DnodeHosts=${CASSANDRA_HOST}"

ENV WASABI_API_JAVA_OPTIONS=${WASABI_API_JAVA_OPTIONS}

COPY --from=base \
    ${WASABI_TARGET_PATH}/wasabi-main-${WASABI_VERSION}-${WASABI_PROFILE}-all.jar /app/wasabi.jar

COPY --from=base \
    ${WASABI_TARGET_PATH}/classes/logback-access.xml \
    ${WASABI_TARGET_PATH}/classes/logback.xml \
    ${WASABI_TARGET_PATH}/classes/metrics.properties \
    ${WASABI_TARGET_PATH}/classes/web.properties \
    /app/modules/analytics/target/classes/analytics.properties \
    /app/modules/api/target/classes/api.properties \
    /app/modules/assignment/target/classes/assignment.properties \
    /app/modules/assignment/target/classes/ehcache.xml \
    /app/modules/auditlog/target/classes/auditlog.properties \
    /app/modules/authentication/target/classes/authentication.properties \
    /app/modules/authorization/target/classes/authorization.properties \
    /app/modules/database/target/classes/database.properties \
    /app/modules/email/target/classes/email.properties \
    /app/modules/event/target/classes/event.properties \
    /app/modules/eventlog/target/classes/eventlog.properties \
    /app/modules/export/target/classes/export.properties \
    /app/modules/repository-datastax/target/classes/cassandra_client_config.properties \
    /app/modules/repository-datastax/target/classes/repository.properties \
    /app/modules/user-directory/target/classes/userDirectory.properties /app/conf/

EXPOSE ${WASABI_PORT_API} ${WASABI_PORT_JMX} ${WASABI_PORT_DEBUG}

CMD java ${WASABI_API_JAVA_OPTIONS} -cp /app/wasabi.jar com.intuit.wasabi.Main
