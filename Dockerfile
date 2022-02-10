FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG UNIFI_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ARG UNIFI_BRANCH="stable"
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    binutils \
    jsvc \
    libcap2 \
    logrotate \
    mongodb-server \
    openjdk-8-jre-headless \
    wget && \
  echo "**** Add Ubiquiti apt sources + install ****" && \
  echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list && \
  wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && \
  apt-mark hold openjdk-11-* && \
  apt-get update && \
  apt-get install unifi -y && \
  mkdir -p /app && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /

# Volumes and Ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 8080 8443 8843 8880
