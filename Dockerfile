# FROM ruby:2.6.0
FROM ruby:3.1-alpine3.15

#useful with guard
RUN apk --update add less
RUN apk add bash && apk add file

COPY advantage-salesforce_sync.gemspec ./
COPY Gemfile ./
COPY Gemfile.lock ./
COPY Guardfile ./
COPY Rakefile ./

WORKDIR /app
ADD . /app

RUN apk add alpine-sdk && gem install bundler && bundle install -j4
