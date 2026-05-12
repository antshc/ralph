#!/usr/bin/env bash
set -euo pipefail

# Run afk_fix_prs every 60 seconds
while true; do
  GH_CONFIG_DIR=/home/ubuntu/.config/gh afk_fix_prs \
    --repo_dir "$AFK_REPO_DIR" \
    --github_user "$AFK_GITHUB_USER" \
    --github_repo "$AFK_GITHUB_REPO"
  sleep 60
done
