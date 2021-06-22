#!/usr/bin/env sh
set -eux

if [ -z "${DEVPISERVER_HOST:-}" ]; then
    DEVPISERVER_HOST="0.0.0.0"
fi

if [ -z "${DEVPISERVER_PORT:-}" ]; then
    DEVPISERVER_PORT="3141"
fi

if [ ! -f "${DEVPISERVER_SERVERDIR:-}/.nodeinfo" ]; then
    echo "Initializing devpi..."
    devpi-init
else
    echo "Already initialized, skipping."
fi

exec devpi-server --restrict-modify root --host="${DEVPISERVER_HOST}" --port="${DEVPISERVER_PORT}" $@
