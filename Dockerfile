# Download base image
FROM debian:latest

# Define the ARG variables for creating docker image
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

# Labels
LABEL org.label-schema.name="Debian base image with S6-Overlay" \
      org.label-schema.description="This is a Debian base image with S6-Overlay" \
      org.label-schema.vendor="Paul NOBECOURT <paul.nobecourt@orange.fr>" \
      org.label-schema.url="https://github.com/pnobecourt/" \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/pnobecourt/docker-debian-s6" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0"

# Define the ENV variable for creating docker image
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL=/bin/bash
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install s6-overlay
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -L -S https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz | tar xvzf - -C / && \
    apt-get purge curl && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /usr/share/groff \
           /usr/share/info \
           /usr/share/linda \
           /usr/share/lintian \
           /usr/share/man \
           /var/lib/apt/lists/* \
           /var/log/* \
           /var/spool/* \
           /var/tmp/* \
           /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           /var/cache/man

# Entrypoint
ENTRYPOINT [ "/init" ]
