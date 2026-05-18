#!/usr/bin/env bash

set -euo pipefail

# Accept compose file path as first argument, or prompt if not provided
if [[ $# -ge 1 && -n "$1" ]]; then
	COMPOSE_FILE="$1"
else
	read -p "Full docker compose file path [$HOME/.ralph/docker-compose.yml]: " COMPOSE_FILE
	COMPOSE_FILE="${COMPOSE_FILE:-$HOME/.ralph/docker-compose.yml}"
fi

COMPOSE_DIR="$(dirname "$COMPOSE_FILE")"
SERVICE_NAME="$(basename "$COMPOSE_DIR")"

# Strip leading dot from service name if present
SERVICE_NAME="${SERVICE_NAME#.}"

# Prefix with "ralph-" if the compose dir is not under a .ralph* parent directory
PARENT_DIR="$(basename "$(dirname "$COMPOSE_DIR")")"
if [[ "$PARENT_DIR" != .ralph* ]]; then
	SERVICE_NAME="ralph-${SERVICE_NAME}"
fi

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

if [[ ! -f "$SERVICE_FILE" ]]; then
	echo "Error: service file not found: $SERVICE_FILE" >&2
	exit 1
fi

sudo systemctl disable --now ${SERVICE_NAME}.service
sudo rm "$SERVICE_FILE"
sudo systemctl daemon-reload

echo "Disabled and removed service: ${SERVICE_NAME}.service"
