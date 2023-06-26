FROM node:18-alpine AS FrontendBuilder

ENV TZ=Asia/Shanghai
ENV CWS_CONFIG_DIR=/app/backend/data/config

RUN mkdir -p /app
COPY frontend /app/frontend

WORKDIR /app/frontend
RUN npm install pnpm -g
RUN pnpm install
RUN pnpm build

FROM python:3.11-alpine AS BackendBuilder

COPY --from=lwthiker/curl-impersonate:0.5-chrome /usr/local /usr/local

ARG PIP_CACHE_DIR=/pip_cache
ARG TARGETARCH

RUN mkdir -p /app/backend

RUN apk add --update caddy gcc musl-dev libffi-dev git
COPY backend/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY Caddyfile /app/Caddyfile
COPY backend /app/backend
COPY --from=FrontendBuilder /app/frontend/dist /app/dist

WORKDIR /app

EXPOSE 80

COPY startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh; mkdir /data
CMD if [ -n "$SWAP" ]; then fallocate -l $(($(stat -f -c "(%a*%s/10)*5" .))) _swapfile && mkswap _swapfile && swapon _swapfile && ls -hla; fi; free -m && /app/startup.sh
