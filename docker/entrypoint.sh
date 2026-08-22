#!/bin/bash
set -e

# Use provided PUID/PGID or default to 1000
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

BINARY="${1:?Error: binary name required}"

echo "Starting with PUID: $USER_ID and PGID: $GROUP_ID"

# Create group if it doesn't exist
if ! getent group hwuser >/dev/null; then
    groupadd -g "$GROUP_ID" hwuser
fi

# Create user if it doesn't exist
if ! getent passwd hwuser >/dev/null; then
    useradd -u "$USER_ID" -g "$GROUP_ID" -m -s /bin/bash hwuser
fi

# Ensure /app and /app/config are owned by the hwuser user
# This is necessary for sqlite and downloads to work correctly
mkdir -p /app
chown -R hwuser:hwuser /app

# If running as root (default Docker behavior), drop privileges using gosu
if [ "$(id -u)" = '0' ]; then
    echo "Dropping privileges to hwuser user..."
    exec gosu hwuser "$BINARY"
fi

# Otherwise just run directly (e.g. if --user was passed to docker run) sd
exec "$BINARY"
