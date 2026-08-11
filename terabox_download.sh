#!/bin/bash
# TeraBox Download Script - Runs on VPS
set -e

SHARE_URL="https://1024terabox.com/s/1ahJz-qdH7h_9One0lXxDoA"
NDUS_TOKEN="tbx_SMvXechHBMJLqqMkPDQMG4VxsW4VzhYTjzkPRTTQr2U"

echo "=== TeraBox Downloader ==="
echo "Share URL: $SHARE_URL"

# Install dependencies
echo "Installing dependencies..."
apt-get update -qq
apt-get install -y -qq python3 python3-pip curl wget
pip3 install -q requests

# Create Python download script
cat > /tmp/terabox_dl.py << 'PYEOF'
import requests
import sys
import re
import json

share_url = "https://1024terabox.com/s/1ahJz-qdH7h_9One0lXxDoA"
ndus = "tbx_SMvXechHBMJLqqMkPDQMG4VxsW4VzhYTjzkPRTTQr2U"

headers = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Cookie": f"ndus={ndus}",
    "Referer": "https://1024terabox.com/"
}

# Step 1: Get share page
print("[1] Fetching share page...")
r = requests.get(share_url, headers=headers, timeout=30)
print(f"    Status: {r.status_code}")

if "not available" in r.text.lower():
    print("    ERROR: Region blocked even on VPS!")
    sys.exit(1)

# Extract jsToken
jsToken = re.search(r'jsToken["']?\s*[:=]\s*["']?([a-f0-9]+)', r.text)
if jsToken:
    jsToken = jsToken.group(1)
    print(f"    jsToken: {jsToken}")
else:
    print("    jsToken not found, trying alternate method...")
    jsToken = ""

# Extract surl
surl = share_url.split("/s/")[1].split("?")[0]
print(f"    surl: {surl}")

# Step 2: Call share API
print("[2] Calling share API...")
api_url = "https://www.terabox.app/api/shorturlinfo"
params = {
    "shorturl": surl,
    "root": "1"
}
if jsToken:
    params["jsToken"] = jsToken

r2 = requests.get(api_url, params=params, headers=headers, timeout=30)
print(f"    Status: {r2.status_code}")
data = r2.json()
print(f"    Response: {json.dumps(data, indent=2)[:500]}")

# Step 3: Get download links
if data.get("errno") == 0 and data.get("list"):
    print("[3] Getting download links...")
    for item in data["list"]:
        print(f"    File: {item.get('server_filename', 'unknown')}")
        print(f"    Size: {item.get('size', 0)} bytes")

        # Get direct download
        fid = item.get("fs_id")
        if fid:
            dl_url = "https://www.terabox.app/api/download"
            dl_params = {
                "fidlist": f"[{fid}]",
                "type": "dlink"
            }
            r3 = requests.get(dl_url, params=dl_params, headers=headers, timeout=30)
            dl_data = r3.json()
            if dl_data.get("errno") == 0 and dl_data.get("dlink"):
                for link in dl_data["dlink"]:
                    print(f"    Download: {link.get('dlink', 'N/A')[:100]}...")
            else:
                print(f"    Download API error: {dl_data}")
else:
    print(f"    Error: {data.get('errmsg', 'Unknown error')}")

PYEOF

python3 /tmp/terabox_dl.py
