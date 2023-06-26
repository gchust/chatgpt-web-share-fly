#!/bin/sh
cd /app
caddy start --config /app/Caddyfile --adapter caddyfile &  # Start caddy in the background
/go/bin/ChatGPT-Proxy-V4 &  # Start ChatGPT-Proxy-V4 in the background
cd /app/backend
# python main.py
exec uvicorn main:app --host 0.0.0.0 --port 8000 --proxy-headers --forwarded-allow-ips '*' --log-config logging_config.yaml &
wait  # Wait for all background tasks to complete