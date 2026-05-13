#!/usr/bin/env bash
set -euo pipefail

# Run afk_fix_prs every 60 seconds
while true; do
  afk_fix_prs \
    --repo_dir "/home/ubuntu/workspace" \
    --github_user "$AFK_GITHUB_USER" \
    --github_repo "$AFK_GITHUB_REPO"
  sleep 60
done
