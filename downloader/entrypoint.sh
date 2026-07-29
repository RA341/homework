#!/bin/bash
set -e

# Use provided PUID/PGID or default to 1000
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}

echo "Starting with PUID: $USER_ID and PGID: $GROUP_ID"

# Create group if it doesn't exist
if ! getent group depot >/dev/null; then
    groupadd -g "$GROUP_ID" depot
fi

# Create user if it doesn't exist
if ! getent passwd depot >/dev/null; then
    useradd -u "$USER_ID" -g "$GROUP_ID" -m -s /bin/bash depot
fi

# Ensure /app and /app/config are owned by the depot user
# This is necessary for sqlite and downloads to work correctly
chown -R depot:depot /app/config

# If running as root (default Docker behavior), drop privileges using gosu
if [ "$(id -u)" = '0' ]; then
    echo "Dropping privileges to depot user..."
    exec gosu depot uv run uvicorn main:app --host 0.0.0.0 --port 8000
fi

# Otherwise just run directly (e.g. if --user was passed to docker run) sd
exec uv run uvicorn main:app --host 0.0.0.0 --port 8000
