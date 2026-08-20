FROM ghcr.io/containerpak/base:main

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    ln -sf /package/claude /usr/bin/claude && \
    cpak-clean-junk

ENV DISABLE_AUTOUPDATER=1

RUN test -L /usr/bin/claude
