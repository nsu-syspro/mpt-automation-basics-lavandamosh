# syntax=docker/dockerfile:1
FROM ubuntu:24.04

WORKDIR /app


COPY . .

RUN make check


ENTRYPOINT exec "/app/build/$(cat config.json | grep -oP '\"name\":\s*\"\K[^\"]+')" "$@"

