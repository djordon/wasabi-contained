ARG WASABI_BASE_IMAGE
FROM ${WASABI_BASE_IMAGE}

ENV NVM_DIR=/usr/local/nvm \
    NVM_VERSION=v0.33.11 \
    NODE_VERSION=8.9.0

WORKDIR $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

ENV NODE_PATH=${NVM_DIR}/versions/node/v${NODE_VERSION}/lib/node_modules \
    PATH=${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:$PATH

RUN npm install -g bower grunt-cli yo

WORKDIR /app/modules/ui

RUN npm install && bower --allow-root install && grunt build

WORKDIR /app

COPY build-ui.sh .
RUN ./build-ui.sh -b false -t false -p development

WORKDIR /app/modules/ui

ARG WASABI_PORT_UI=9090
ARG WASABI_API

ENV API_HOST=${WASABI_API} \
    PORT=${WASABI_PORT_UI} \
    UI_HOST=0.0.0.0

EXPOSE ${WASABI_PORT_UI}

CMD ["grunt", "serve:dist"]
