# syntax=docker/dockerfile:1
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    make \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN make clean && make check

ENTRYPOINT ["sh", "-c", "exec /app/build/$(jq -r .name config.json) \"$@\"", \"--\"]


