# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        make \
        jq \
        bash \
        coreutils \
        diffutils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN make clean && make check

ENTRYPOINT ["/app/build/wordcount"]