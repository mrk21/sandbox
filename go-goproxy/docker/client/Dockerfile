FROM ubuntu
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install basic packages
RUN apt-get update -qq && \
    apt-get install -y build-essential tree vim less curl dnsutils net-tools procps && \
    apt-get install -y --no-install-recommends apt-utils
