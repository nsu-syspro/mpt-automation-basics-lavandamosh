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

ENTRYPOINT ["sh", "-c", "exec /app/build/$(jq -r .name config.json) \"$@\"", "--"]

