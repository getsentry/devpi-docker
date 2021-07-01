#!/usr/bin/env sh
set -eu

set_password() {
    expect <<-'EOF'
        set timeout -1

        spawn /usr/local/bin/devpi-passwd root

        expect "enter password" { send "$env(DEVPISERVER_PASSWORD)\r" }
        expect "repeat password" { send "$env(DEVPISERVER_PASSWORD)\r" }

        expect "committed: keys:"
        wait
EOF
}

if [ -z "${DEVPISERVER_HOST:-}" ]; then
    export DEVPISERVER_HOST="0.0.0.0"
fi

if [ -z "${DEVPISERVER_PORT:-}" ]; then
    export DEVPISERVER_PORT="3141"
fi

if [ -z "${DEVPISERVER_PASSWORD:-}" ]; then
    # Generate a random password if not provided
    export DEVPISERVER_PASSWORD=$(</dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
fi

if [ ! -f "${DEVPISERVER_SERVERDIR:-}/.nodeinfo" ]; then
    echo "Initializing devpi..."
    devpi-init

    # Set the root password
    set_password
else
    echo "Already initialized, skipping."
fi

set -x
exec devpi-server --restrict-modify root --host="${DEVPISERVER_HOST}" --port="${DEVPISERVER_PORT}" $@
