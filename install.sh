#!/usr/bin/env bash
set -euo pipefail

read -p "Installation directory [.ralph]: " INSTALL_DIR
INSTALL_DIR="${INSTALL_DIR:-.ralph}"

mkdir -p "$HOME/$INSTALL_DIR"
curl -L https://github.com/antshc/ralph/releases/latest/download/ralph.tar.gz | tar -xz -C "$HOME/$INSTALL_DIR"

echo "Installed runtime files into: $HOME/$INSTALL_DIR"
