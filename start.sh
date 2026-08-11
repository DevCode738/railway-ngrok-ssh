#!/bin/bash
set -e

echo "=== DRC Railway-Ngrok SSH Tunnel ==="
echo "Starting SSH service..."
service ssh start

echo "Authenticating ngrok..."
ngrok config add-authtoken "$NGROK_AUTHTOKEN"

echo "Starting ngrok TCP tunnel on port 22..."
# Paid plan allows TCP tunnels + static domains
ngrok tcp 22 --region in &

# Keep container alive
tail -f /dev/null
