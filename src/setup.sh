#!/usr/bin/env bash
# setup.sh — Runs at container startup (after mitmproxy is ready).
#
# Installs Copilot plugins that require network access through the proxy.
#
set -euo pipefail

copilot plugin install review@brain
copilot plugin install wf@brain

echo "setup.sh: plugin setup complete"
