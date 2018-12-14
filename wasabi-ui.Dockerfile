FROM wasabi-base:latest

ENV NVM_DIR /usr/local/nvm
ENV NVM_VERSION v0.33.11
ENV NODE_VERSION 8.9.0

WORKDIR $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g bower grunt-cli yo

WORKDIR /app/modules/ui

RUN npm install && bower --allow-root install && grunt build

WORKDIR /app

COPY build-ui.sh .
RUN ./build-ui.sh -b false -t false -p development

WORKDIR /app/modules/ui

ARG WASABI_UI_PORT=9090
ENV WASABI_UI_PORT=${WASABI_UI_PORT}

ARG WASABI_API
ENV API_HOST=${WASABI_API}

EXPOSE ${WASABI_UI_PORT}

ENV PORT=${WASABI_UI_PORT}
ENV UI_HOST=0.0.0.0

CMD ["grunt", "serve:dist"]
