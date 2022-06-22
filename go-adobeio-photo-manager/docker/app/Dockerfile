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
# App base
#------------------------------------------------------------------------------
FROM golang:1.17.3-bullseye AS base
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less curl dnsutils net-tools procps jq && \
    apt-get install -y --no-install-recommends apt-utils

# Install Entrykit
COPY --from=build_entrykit /entrykit/build/Linux/entrykit /bin/entrykit
RUN entrykit --symlink

# Change /bin/sh to bash from dash
# @see https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

# Set shell environments
ENV APP_HOME /app
ENV SHELL /bin/bash
ENV EDITOR vim
COPY ./docker/app/bashrc.sh /root/.bashrc

# Make application directory
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME


#------------------------------------------------------------------------------
# for development
#------------------------------------------------------------------------------
FROM base AS dev

# Install gopls
# @see https://github.com/golang/tools/tree/master/gopls
RUN go install golang.org/x/tools/gopls@latest

# Install devtool
ENV PATH /root/bin:$PATH
RUN echo "export PATH=/root/bin:\$PATH" >> /root/.profile
COPY ./docker/app/bin /root/bin
