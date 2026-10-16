# syntax=docker/dockerfile:1

FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        make \
        jq \
        bash \
        coreutils \
        diffutils

WORKDIR /src
COPY . .

RUN make clean && make check

FROM ubuntu:24.04

WORKDIR /app
COPY --from=builder /src/build/wordcount /app/wordcount

ENTRYPOINT ["/app/wordcount"]