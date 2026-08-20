FROM ubuntu:26.04

COPY cpak-apt.conf /etc/apt/apt.conf.d/90cpak
COPY --chmod=0755 cpak-clean-junk /usr/bin/cpak-clean-junk

ARG TARGETARCH
ARG CLAUDE_VERSION=2.1.237
ARG CLAUDE_SHA256_AMD64=73975167f0108693cf6fd6614994781657ebb8456ebef5d247458734abfb3916
ARG CLAUDE_SHA256_ARM64=a701cfb6bb4703abc6f3ce47508c878ca8158ebdbeacd5c35c7d510c7bc70177

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    case "$TARGETARCH" in \
        amd64) platform=linux-x64; checksum="$CLAUDE_SHA256_AMD64" ;; \
        arm64) platform=linux-arm64; checksum="$CLAUDE_SHA256_ARM64" ;; \
        *) echo "unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
    esac && \
    curl -fsSLo /usr/bin/claude \
        "https://downloads.claude.ai/claude-code-releases/${CLAUDE_VERSION}/${platform}/claude" && \
    echo "${checksum}  /usr/bin/claude" | sha256sum -c - && \
    chmod 0755 /usr/bin/claude && \
    cpak-clean-junk

# The package is what gets updated, so the tool must not replace itself: an
# installation that rewrites its own binary is one the integrity ledger no
# longer answers for, and cpak update is how a new version arrives.
ENV DISABLE_AUTOUPDATER=1

RUN test -x /usr/bin/claude
