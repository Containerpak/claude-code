FROM ubuntu:26.04

COPY cpak-apt.conf /etc/apt/apt.conf.d/90cpak
COPY --chmod=0755 cpak-clean-junk /usr/bin/cpak-clean-junk

ARG TARGETARCH
ARG CLAUDE_VERSION=2.1.235
ARG CLAUDE_SHA256_AMD64=bfcf0ae2dbf94b2b6a106074aabf3938b9a10889c3b678e4cb5a00c03274d5d5
ARG CLAUDE_SHA256_ARM64=cff9592faa292db0f6ac21874f151b8c3d44e23bf0ab9fd1bcca95edc3469549

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
