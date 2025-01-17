ARG ELIXIR_IMAGE_VERSION=1.11.4
ARG ERLANG_IMAGE_VERSION=23.3
ARG RELEASE_IMAGE_VERSION=3.13.2

FROM hexpm/elixir:${ELIXIR_IMAGE_VERSION}-erlang-${ERLANG_IMAGE_VERSION}-alpine-${RELEASE_IMAGE_VERSION} AS build

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  nodejs \
  npm \
  git \
  build-base && \
  mix local.rebar --force && \
  mix local.hex --force

WORKDIR /app

COPY . .

ENV MIX_ENV=prod

RUN mix do deps.get, deps.compile, compile

RUN cd assets && \
  npm ci --progress=false --no-audit --loglevel=error && \
  npm run deploy && \
  cd - && \
  mix phx.digest


RUN mix release

#
# Release
#
FROM alpine:${RELEASE_IMAGE_VERSION} AS app

RUN apk update && \
  apk add --no-cache \
  bash \
  openssl-dev

WORKDIR /opt/app
EXPOSE 4000

RUN addgroup -g 1000 appuser && \ 
  adduser -u 1000 -G appuser -g appuser -s /bin/sh -D appuser && \
  chown 1000:1000 /opt/app

COPY --from=build --chown=1000:1000 /app/_build/prod/rel/elixir_google_scraper ./
COPY bin/start.sh ./bin/start.sh

USER app_user

CMD bin/start.sh
