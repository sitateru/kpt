FROM ruby:2.5.1-alpine3.7

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN set -ex && \
  apk update && \
  apk add --no-cache libstdc++ postgresql-dev tzdata build-base bash && \
  bundle install --no-cache && \
  apk del build-base

COPY . /myapp
