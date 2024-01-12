FROM ruby:3.2.2
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less dnsutils net-tools && \
    apt-get install -y --no-install-recommends apt-utils

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

# Install bundler
RUN gem install bundler

# Install PostgreSQL client
RUN apt-get install -y postgresql-client-15

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
