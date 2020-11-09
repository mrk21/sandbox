#------------------------------------------------------------------------------
# Build Entrykit 0.4.1
# Entrykit 0.4.1 is not released, so we build from source
#------------------------------------------------------------------------------
FROM golang:1.15 AS build_entrykit
WORKDIR /
RUN git clone https://github.com/progrium/entrykit.git && \
    cd entrykit && \
    git checkout 799207016380fc3d22e2d1f76894a7ce5c98613c && \
    make


#------------------------------------------------------------------------------
# Base image
#------------------------------------------------------------------------------
FROM golang:1.15 AS base
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less curl dnsutils net-tools procps file && \
    apt-get install -y --no-install-recommends apt-utils

# Install Redis CLI
RUN apt-get install -y redis-tools

# Install Entrykit
COPY --from=build_entrykit /entrykit/build/Linux/entrykit /bin/entrykit
RUN entrykit --symlink

# Change /bin/sh from dash to bash
# @see https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

# Install REPL for Golang
RUN go get -u github.com/motemen/gore/cmd/gore

# Set shell environments
ENV APP_HOME /app
ENV SHELL /bin/bash
ENV EDITOR vim
ENV PATH $APP_HOME/bin:$PATH
RUN echo "export PATH=$APP_HOME/bin:\$PATH" >> /root/.profile
COPY ./docker/app/bashrc.sh /root/.bashrc

# Make application directory
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME


#------------------------------------------------------------------------------
# for development
#------------------------------------------------------------------------------
FROM base AS development
