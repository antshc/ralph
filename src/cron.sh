#!/usr/bin/env bash
set -euo pipefail

fix_prs_loop() {
  while true; do
    afk_fix_prs \
      --github_user "$AFK_FIX_PRS_GITHUB_USER" \
      --github_repo "$AFK_FIX_PRS_GITHUB_REPO"
    sleep "${AFK_FIX_PR_SLEEP:-10}"
  done
}

dev_loop() {
  while true; do
    afk_dev \
      --github_repo_board "$AFK_DEV_GITHUB_REPO"
    sleep "${AFK_DEV_SLEEP:-10}"
  done
}

pids=()

if [[ "${AFK_DISABLE_FIX_PRS:-}" != "1" ]]; then
  fix_prs_loop &
  pids+=($!)
fi

if [[ "${AFK_DISABLE_DEV:-}" != "1" ]]; then
  dev_loop &
  pids+=($!)
fi

wait "${pids[@]}"
