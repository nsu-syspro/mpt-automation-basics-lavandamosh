# syntax=docker/dockerfile:1
FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        jq \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN make
RUN make check

ENTRYPOINT ["./build/wordcount"]