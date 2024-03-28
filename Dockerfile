FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG PP_VERSION
ARG VERSION
LABEL build_version="Duarte Ferreira Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="dngferreira"

# title
ENV TITLE=PortfolioPerformance

RUN \
  echo "**** install packages ****" && \
  mkdir -p /usr/share/man/man1 && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    default-jdk \
    thunar &&\
  echo "**** install portfolio performance ****" && \
  if [ -z ${PP_VERSION+x} ]; then \
    PP_VERSION=$(curl -sLX GET "https://api.github.com/repos/portfolio-performance/portfolio/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "**** version: ${PP_VERSION} ****" && \
  echo "https://github.com/portfolio-performance/portfolio/releases/download/${PP_VERSION}/PortfolioPerformance-${PP_VERSION}-linux.gtk.x86_64.tar.gz" && \
  curl -o \
    /tmp/pp.tgz -L \
    "https://github.com/portfolio-performance/portfolio/releases/download/${PP_VERSION}/PortfolioPerformance-${PP_VERSION}-linux.gtk.x86_64.tar.gz" && \
  tar -zxf /tmp/pp.tgz -C /usr/share && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /
RUN chmod +x /usr/bin/PortfolioPerformance 
# ports and volumes
EXPOSE 3000

VOLUME /config