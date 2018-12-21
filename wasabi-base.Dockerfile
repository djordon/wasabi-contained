FROM maven:3.6.0-jdk-8-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG WASABI_MAVEN_SETTINGS=
ARG WASABI_PROFILE=development
ARG WASABI_VERSION=1.0.20181205072204

ENV WASABI_PROFILE=${WASABI_PROFILE} \
    WASABI_MAVEN_SETTINGS=${WASABI_MAVEN_SETTINGS} \
    WASABI_VERSION=${WASABI_VERSION}

RUN git clone --depth 1 https://github.com/intuit/wasabi.git . --branch ${WASABI_VERSION}

RUN mvn ${WASABI_MAVEN_SETTINGS} \
    -P${WASABI_PROFILE} clean \
    -Dmaven.test.skip=true package javadoc:aggregate
