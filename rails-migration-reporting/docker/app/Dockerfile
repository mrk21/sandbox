#------------------------------------------------------------------------------
# Build Entrykit 0.4.1
# Entrykit 0.4.1 hasn't been released yet, so we build from the source codes on the master branch.
#------------------------------------------------------------------------------
FROM golang AS build_entrykit
WORKDIR /
RUN git clone https://github.com/progrium/entrykit.git && \
    cd entrykit && \
    git checkout 799207016380fc3d22e2d1f76894a7ce5c98613c && \
    make

#------------------------------------------------------------------------------
# Base
#------------------------------------------------------------------------------
FROM ruby:2.7.1 AS base
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less curl dnsutils net-tools procps && \
    apt-get install -y --no-install-recommends apt-utils

# Install MySQL 5.7 client and native libraries
# @see https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup
COPY docker/app/mysql_pubkey.asc /tmp/mysql_pubkey.asc
RUN apt-key add /tmp/mysql_pubkey.asc && \
    echo 'deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7' | tee /etc/apt/sources.list.d/mysql.list && \
    apt-get update && \
    apt-get install -y mysql-client

# Install Node.js 10.x and yarn
# @see node https://askubuntu.com/questions/786272/why-does-installing-node-6-x-on-ubuntu-16-04-actually-install-node-4-2-6
# @see yarn https://yarnpkg.com/en/docs/install#linux-tab
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y nodejs yarn

# Install bundler
RUN gem install bundler

# Install Entrykit
COPY --from=build_entrykit /entrykit/build/Linux/entrykit /bin/entrykit
RUN entrykit --symlink

# Change /bin/sh to bash from dash
# @see https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

# Set shell environments
ENV APP_HOME /app/rails-migration-reporting
ENV SHELL /bin/bash
ENV EDITOR vim
ENV PATH $APP_HOME/bin:$PATH
RUN echo "export PATH=$APP_HOME/bin:\$PATH" >> /root/.profile
COPY ./docker/app/bashrc.sh /root/.bashrc

# Make application directory
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
