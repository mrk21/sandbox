FROM ruby:3.2.2
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less dnsutils net-tools jq && \
    apt-get install -y --no-install-recommends apt-utils

# Install MySQL client
RUN apt-get install -y default-mysql-client

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

# Install bundler
RUN gem install bundler

ENV APP_HOME /sandbox/rails-shrine
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Install Vips
RUN apt install -y libvips-dev

# Change /bin/sh to bash from dash
# @see https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

# NOTE: A login shell overrides the PATH environment variable set by docker,
# so I set same value as the environment variable to .profile.
# By means of this, PATH environment variable is same value on non login shell and login shell.
ENV PATH=$APP_HOME/bin:$PATH
RUN echo "export PATH=$PATH" >> /root/.profile

ENV SHELL=/bin/bash
ENV SERVICE=app
ENV EDITOR=vi
ENV RAILS_LOG_TO_STDOUT=1
COPY ./docker/app/bashrc.sh /root/.bashrc
