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

# Example: install a Copilot plugin from a GitHub release
# gh extension install owner/gh-my-skill

# Example: Add copilot plugin marketplace and install a plugin from there
# copilot plugin marketplace add github/awesome-copilot

# example: install a Copilot plugin from the marketplace with a specific version
# copilot plugin install dotnet@awesome-copilot

# Example: Install skill
# gh skill install github/awesome-copilot git-commit

run_or_skip() {
    local desc="$1"
    local skip_pattern="$2"
    shift 2
    local output rc
    output=$("$@" 2>&1) && rc=0 || rc=$?
    if [ $rc -eq 0 ]; then
        echo "INFO: $desc"
    elif echo "$output" | grep -qE "$skip_pattern"; then
        echo "INFO: $desc — already present, skipping"
    else
        echo "ERROR: $desc failed — $output" >&2
        return 1
    fi
}

run_or_skip "install brain-tools" "already seems to be installed" \
    pipx install git+https://github.com/antshc/brain.git

run_or_skip "add marketplace 'brain'" "already registered" \
    copilot plugin marketplace add antshc/brain

run_or_skip "install plugin ralph@brain" "already installed|already exists" \
    copilot plugin install ralph@brain

run_or_skip "install plugin review@brain" "already installed|already exists" \
    copilot plugin install review@brain

run_or_skip "install plugin wf@brain" "already installed|already exists" \
    copilot plugin install wf@brain

echo "setup.sh: custom setup complete"
