#!/usr/bin/env bash
# setup.sh — Optional startup script example
#
# Mount this file into the container to run custom setup steps at startup:
#
#   docker-compose.yml volumes:
#     - ./setup.sh:/etc/sandbox/setup.sh:ro
#
# This script runs as the 'ubuntu' user after mitmproxy and iptables are
# configured (network access through the proxy is available). If it exits
# non-zero, the container aborts.
#
# Available environment variables:
#   COPILOT_GITHUB_TOKEN  — GitHub token for Copilot
#   GH_TOKEN              — GitHub token for gh CLI (if set, overrides ~/.config/gh mount if set)
#   HTTP_PROXY            — http://127.0.0.1:18080
#   HTTPS_PROXY           — http://127.0.0.1:18080
#   NODE_EXTRA_CA_CERTS   — path to mitmproxy CA cert (trusted by Node.js)
#
set -euo pipefail

# Available marketplaces:
#   copilot plugin marketplace add github/copilot-plugins
#   copilot plugin marketplace add github/awesome-copilot
#   copilot plugin marketplace add antshc/brain    ← already added at build time

# example: install a Copilot plugin from the marketplace with a specific version
# copilot plugin install dotnet@awesome-copilot

# Example: Install skill
# gh skill install github/awesome-copilot git-commit

set -euo pipefail

copilot plugin install ralph@brain
copilot plugin install review@brain
copilot plugin install wf@brain

echo "setup.sh: plugins installed"