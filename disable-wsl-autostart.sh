#!/usr/bin/env bash

set -euo pipefail

echo "Available ralph services:"
mapfile -t SERVICES < <(systemctl list-units --type=service --all --no-legend | awk '{print $1}' | grep '^ralph-')

if [[ ${#SERVICES[@]} -eq 0 ]]; then
	echo "No ralph services found." >&2
	exit 1
fi

for i in "${!SERVICES[@]}"; do
	STATUS=$(systemctl is-active "${SERVICES[$i]}" 2>/dev/null || true)
	echo "  $((i+1))) ${SERVICES[$i]} [$STATUS]"
done

echo ""
read -p "Enter service name to remove: " SERVICE_NAME </dev/tty

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}"
# Append .service if not already present
[[ "$SERVICE_NAME" != *.service ]] && SERVICE_FILE="${SERVICE_FILE}.service" && SERVICE_NAME="${SERVICE_NAME}.service"

if [[ ! -f "$SERVICE_FILE" ]]; then
	echo "Error: service file not found: $SERVICE_FILE" >&2
	exit 1
fi

sudo systemctl disable --now "$SERVICE_NAME"
sudo rm "$SERVICE_FILE"
sudo systemctl daemon-reload

echo "Disabled and removed service: ${SERVICE_NAME}"
