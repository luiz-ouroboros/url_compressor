# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /app

RUN apt-get update

RUN apt-get install -y libmariadb-dev build-essential libpq-dev postgresql-client

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler && bundle install

COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
