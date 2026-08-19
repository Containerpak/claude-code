# Claude Code

Anthropic's coding agent for the terminal, packaged as a cpak.

## Why it does not update itself

The upstream tool replaces its own binary when a new version appears. Here that
is turned off, and the package is what carries a new version: an installation
that rewrites itself is one the integrity ledger no longer answers for, and the
agent is the most privileged thing on a development machine.

A scheduled job follows the published release, moves the pinned version and
checksum, and that is what rebuilds the image. `cpak update` brings it over.

## Toolchains

The agent runs whatever a project needs, and inside a package it can only run
what is there. Every cpak SDK is offered as an addon, so the machine's owner
decides which ones come along:

```bash
cpak addon list github.com/containerpak/claude-code
cpak addon enable github.com/containerpak/claude-code github.com/containerpak/sdk-scm
```

The SSH and GPG agent sockets are forwarded, so signed commits and pulls work
with the keys already on the machine.
