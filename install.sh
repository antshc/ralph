#!/usr/bin/env bash
set -euo pipefail

VARIANT="${RALPH_VARIANT:-latest}"

read -p "Installation directory [.ralph]: " INSTALL_DIR
INSTALL_DIR="${INSTALL_DIR:-.ralph}"

case "$VARIANT" in
  latest|main)
    URL="https://github.com/antshc/ralph/releases/latest/download/ralph.tar.gz"
    ;;
  dev)
    URL="https://github.com/antshc/ralph/releases/download/dev/ralph-dev.tar.gz"
    ;;
  workspace)
    URL="https://github.com/antshc/ralph/releases/download/workspace/ralph-workspace.tar.gz"
    ;;
  *)
    echo "Unknown variant: $VARIANT. Use latest, dev, or workspace." >&2
    exit 1
    ;;
esac

mkdir -p "$HOME/$INSTALL_DIR"
curl -L "$URL" | tar -xz -C "$HOME/$INSTALL_DIR"

echo "Installed runtime files into: $HOME/$INSTALL_DIR"
