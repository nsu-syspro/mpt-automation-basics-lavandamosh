FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        make \
        jq \
        bash \
        coreutils \
        diffutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN make clean && make check && \
    APP_NAME=$(jq -r .name config.json) && \
    ln -s "/app/build/${APP_NAME}" /app/build/wordcount

ENTRYPOINT ["/app/build/wordcount"]

