FROM cassandra:3.11.3

WORKDIR /wasabi

RUN git clone --depth 1 https://github.com/intuit/wasabi.git /wasabi --branch ${WASABI_VERSION}

ADD https://github.com/hhandoko/cassandra-migration/releases/download/cassandra-migration-0.15/cassandra-migration-0.15-jar-with-dependencies.jar .
RUN mkdir -p /wasabi/migrations && cp modules/repository-datastax/src/main/resources/com/intuit/wasabi/repository/impl/cassandra/migration /wasabi/migrations
ADD cassandra-setup.sh .

ENV CASSANDRA_MIGRATION_DIR=/wasabi/migrations
ENV CASSANDRA_MIGRATION_JAR=/wasabi/cassandra-migration-0.15-jar-with-dependencies.jar

ARG CASSANDRA_USER
ARG CASSANDRA_PASSWORD
ARG CASSANDRA_HOST

ENV CASSANDRA_USER=${CASSANDRA_USER}
ENV CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD}
ENV CASSANDRA_HOST=${CASSANDRA_HOST}

CMD ["sh", "/wasabi/cassandra-setup.sh"]
