FROM ruby:3.3.0
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less dnsutils net-tools && \
    apt-get install -y --no-install-recommends apt-utils

# Install MySQL client
RUN apt-get install -y default-mysql-client

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

# Install bundler
RUN gem install bundler

ENV APP_HOME /sandbox/rails-cloud-pubsub
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
