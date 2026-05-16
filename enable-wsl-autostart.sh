#!/usr/bin/env bash

set -euo pipefail

# Accept compose file path as first argument, or prompt if not provided
if [[ $# -ge 1 && -n "$1" ]]; then
	COMPOSE_FILE="$1"
else
	read -p "Full docker compose file path [$HOME/.ralph/docker-compose.yml]: " COMPOSE_FILE
	COMPOSE_FILE="${COMPOSE_FILE:-$HOME/.ralph/docker-compose.yml}"
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
	echo "Error: docker compose file not found: $COMPOSE_FILE" >&2
	exit 1
fi

COMPOSE_DIR="$(dirname "$COMPOSE_FILE")"

sudo tee /etc/systemd/system/ralph.service >/dev/null <<EOF
[Unit]
Description=Ralph Docker Compose Service
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$COMPOSE_DIR
ExecStart=/usr/bin/docker compose -f $COMPOSE_FILE up -d
ExecStop=/usr/bin/docker compose -f $COMPOSE_FILE down

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now ralph.service

echo "Enabled service: ralph.service (compose file: $COMPOSE_FILE)"
