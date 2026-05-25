#!/usr/bin/env bash
set -euo pipefail

while true; do
  afk_fix_prs \
    --github_user "$AFK_GITHUB_USER" \
    --github_repo "$AFK_GITHUB_REPO"
  sleep "$AFK_RALPH_FIX_PR_SLEEP"
done
