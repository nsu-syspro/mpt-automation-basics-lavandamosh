# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем минимальный набор утилит, критически необходимый для работы Makefile и тестов
RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    diffutils \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем всё содержимое репозитория
COPY . .

# Теперь тесты пройдут успешно, так как jq доступен внутри контейнера
RUN make check

# Динамическая Shell-форма точки входа (вырезает актуальное имя из config.json без jq на старте)
ENTRYPOINT ["sh", "-c", "exec /app/build/$(cat config.json | grep -oP '\"name\":\\s*\"\\K[^\"]+') \"$@\"", "--"]
