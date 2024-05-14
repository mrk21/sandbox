FROM ruby:3.3 AS base
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less dnsutils net-tools jq && \
    apt-get install -y --no-install-recommends apt-utils

ENV APP_HOME /sandbox/k8s-argo-workflow
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

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

RUN gem install bundler

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "9292"]


FROM base AS prod
COPY ./Gemfile $APP_HOME/Gemfile
COPY ./Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install
COPY . $APP_HOME
