# Railway + Ngrok SSH Tunnel

Static IP VPS via Railway + Ngrok paid plan.

## Setup

1. Fork/clone this repo
2. Deploy on Railway
3. Add environment variable: `NGROK_AUTHTOKEN=3HTuMN71NRfGZuEfYR3f8pzpCnj_6xCUE5SZPE9a6rpQijPJi`
4. Railway deploys → ngrok gives static TCP endpoint
5. SSH: `ssh root@<ngrok-host> -p <ngrok-port>`
6. Password: `Anony#234`

## Static IP (Reserved TCP Address)

Since you have ngrok paid plan, reserve a TCP address from ngrok dashboard:
- Go to https://dashboard.ngrok.com/cloud-edge/tcp-addresses
- Reserve a TCP address (e.g., `1.tcp.in.ngrok.io:12345`)
- Add env var: `NGROK_TCP_ADDR=1.tcp.in.ngrok.io:12345`
- The start script will use it automatically

## Notes
- Port 22 exposed via ngrok TCP tunnel
- Static IP via ngrok paid plan (reserved TCP address)
- Region: India (`in`)
- SSH password auth enabled for root
