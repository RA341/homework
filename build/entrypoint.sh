#!/bin/bash
set -euo pipefail

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

ENV_VARS=("HW_DOWNLOAD_DIR" "HW_BROWSER_DIR" "HW_ASSET_DIR" "HW_DATABASE_DIR" "HW_UPLOAD_DIR" "SCRIBE_BROWSER_DIR" "SCRIBE_DOWNLOAD_DIR")

for var_name in "${ENV_VARS[@]}"; do
    # Resolve the indirect variable reference
    target_path="${!var_name:-}"

    # Only run if the variable is defined and non-empty
    if [[ -n "$target_path" ]]; then
        mkdir -p "$target_path"
        chown -R "$USER_ID:$GROUP_ID" "$target_path"
        # Alternatively: chown -R hwuser:hwuser "$target_path"
    fi
done

# If running as root (default Docker behavior), drop privileges using gosu
if [ "$(id -u)" = '0' ]; then
    exec gosu hwuser "$BINARY"
fi

# Otherwise just run directly (e.g. if --user was passed to docker run)
exec "$BINARY"
