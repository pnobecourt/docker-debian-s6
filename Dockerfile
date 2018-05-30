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

# Install S6Overlay
RUN apt-get update && \
    apt-get install -y --no-install-recommends aptitude curl && \
    curl -L -s https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz | tar xvzf - -C / && \
    apt-get purge curl && \
    apt-get purge $(aptitude search '~i!~M!~prequired!~pimportant!~R~prequired!~R~R~prequired!~R~pimportant!~R~R~pimportant!busybox!grub!initramfs-tools' | awk '{print $2}') && \
    apt-get purge aptitude && \
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
           /var/tmp/*
           /var/lib/apt/lists/*
           /tmp/*
           /var/tmp/*
           /var/cache/man && \
           (( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
           (( find /usr/share/doc -empty|xargs rmdir || true ))

# Entrypoint
ENTRYPOINT [ "/init" ]
