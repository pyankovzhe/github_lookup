FROM ruby:3.0.2-alpine3.14 AS builder

RUN apk update && apk --update add \
    libcurl && \
    apk --update add --virtual .build-dependencies \
    build-base \
    gcc \
    automake \
    ruby-dev \
    libc-dev

WORKDIR /app

FROM builder AS development
COPY Gemfile* /app/
RUN bundle install
COPY . /app

FROM development AS release
RUN apk del .build-dependencies

ENV APP_ENV=production
EXPOSE 9292
CMD [ "bundle", "exec", "puma", "-p", "9292" ]
