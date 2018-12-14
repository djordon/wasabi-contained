FROM ubuntu:xenial-20181113 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        maven default-jdk git-flow ruby ruby-compass curl bzip2 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /etc/environment

WORKDIR /app

ARG WASABI_VERSION=1.0.20181205072204
ENV WASABI_VERSION=${WASABI_VERSION}

RUN git clone --depth 1 https://github.com/intuit/wasabi.git . --branch ${WASABI_VERSION}

ARG WASABI_PROFILE=development
ENV WASABI_PROFILE=${WASABI_PROFILE}

ARG WASABI_MAVEN=
ENV WASABI_MAVEN=${WASABI_MAVEN}

RUN mvn ${WASABI_MAVEN} -P${WASABI_PROFILE} clean -Dmaven.test.skip=true package javadoc:aggregate
