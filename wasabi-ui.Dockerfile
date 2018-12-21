ARG WASABI_BASE_IMAGE
FROM ${WASABI_BASE_IMAGE} AS base

FROM node:8.14.0-stretch-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bzip2 \
        git \
        ruby \
        ruby-compass \
    && rm -rf /var/lib/apt/lists/*

ARG WASABI_API
ARG WASABI_PROFILE
ARG WASABI_PORT_UI=9090

ENV API_HOST=${WASABI_API} \
    PORT=${WASABI_PORT_UI} \
    UI_HOST=0.0.0.0 \
    WASABI_PROFILE=${WASABI_PROFILE}

RUN npm install -g bower grunt-cli yo

COPY --from=base /app/modules/ui/ /app/modules/ui/

WORKDIR /app/modules/ui

RUN npm install && bower --allow-root install && grunt build

EXPOSE ${WASABI_PORT_UI}

CMD ["grunt", "serve:dist"]
