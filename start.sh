#!/bin/bash
set -e

NGROK_TOKEN="3HTuMN71NRfGZuEfYR3f8pzpCnj_6xCUE5SZPE9a6rpQijPJi"

echo "=== DRC Railway-Ngrok SSH Tunnel ==="
echo "Starting SSH service..."
service ssh start

echo "Authenticating ngrok..."
ngrok config add-authtoken "$NGROK_TOKEN"

echo "Starting ngrok TCP tunnel on port 22..."
ngrok tcp 22 --region in &

# Keep container alive
tail -f /dev/null
