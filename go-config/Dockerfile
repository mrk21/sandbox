FROM golang:1.21
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less dnsutils net-tools jq

# Install Go Language Server
RUN go install golang.org/x/tools/gopls@latest

# /bin/sh change to bash from dash
# @see https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure dash

# Set application directory
ENV APP_HOME /app/go-config
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ENV PATH $APP_HOME/bin:$PATH
