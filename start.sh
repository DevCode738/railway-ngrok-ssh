#!/bin/bash
set -e

echo "=== DRC Railway-Ngrok SSH Tunnel ==="
echo "Starting SSH service..."
service ssh start

echo "Authenticating ngrok..."
ngrok config add-authtoken "$NGROK_AUTHTOKEN"

echo "Starting ngrok TCP tunnel on port 22..."

# If reserved TCP address is set, use it for static IP
if [ -n "$NGROK_TCP_ADDR" ]; then
    echo "Using reserved TCP address: $NGROK_TCP_ADDR"
    ngrok tcp 22 --region in --remote-addr "$NGROK_TCP_ADDR" &
else
    echo "No reserved address set — ngrok will assign dynamic (upgrade to static in dashboard)"
    ngrok tcp 22 --region in &
fi

# Keep container alive
tail -f /dev/null
