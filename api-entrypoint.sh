#!/usr/bin/env bash

APP_NAME=wasabi-main-${WASABI_VERSION}-${WASABI_PROFILE}
WASABI_HOME=${WASABI_TARGET_PATH}/${APP_NAME}
WASABI_CLASSPATH=${WASABI_HOME}/lib/${APP_NAME}-all.jar

[ -z "$JAVA_OPTIONS" ] && export JAVA_OPTIONS="\
  -Xms256m\
  -Xmx256m\
  -server\
  -XX:+HeapDumpOnOutOfMemoryError\
  -XX:HeapDumpPath=${WASABI_HOME}/logs/java_1.hprof\
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
  -Dlogback.configurationFile=${WASABI_HOME}/conf/logback.xml\
  -Djava.util.logging.config.file=${WASABI_HOME}/conf/logging.properties\
  -Ddatabase.url.host=${MYSQL_HOSTNAME}\
  -Ddatabase.url.port=${MYSQL_PORT}\
  -Ddatabase.url.dbname=${MYSQL_DATABASE}\
  -Ddatabase.user=${MYSQL_USER}\
  -Ddatabase.password=${MYSQL_PASSWORD}\
  -Dusername=${CASSANDRA_USER}\
  -Dpassword=${CASSANDRA_PASSWORD}\
  -DnodeHosts=${CASSANDRA_HOST}"

java ${JAVA_OPTIONS} -cp ${WASABI_CLASSPATH} com.intuit.wasabi.Main
