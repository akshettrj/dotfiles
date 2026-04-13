#!/bin/bash

set -euo pipefail

SERVER="akshettrj@oracle_ampere_hyd"

declare -a PLUGINS_LIST=(
    "catppuccin"
    "pyrefly"
    "gruvbox-material"
    "mcp-server-gitlab"
)

# Expand array locally so remote never sees an unset variable (remote has set -u).
# Using * joins with space; remote receives literal list in the for loop.
PLUGINS_FOR_REMOTE="${PLUGINS_LIST[*]-}"

DOWNLOAD_BASE="https://api.zed.dev/extensions"

ssh "$SERVER" /usr/bin/env bash << EOF
    set -eu
    rm -rf /tmp/zed_extensions
    mkdir -p /tmp/zed_extensions

    for extension_id in $PLUGINS_FOR_REMOTE
    do
        if [ -n "\$extension_id" ]; then
            echo "Downloading extension: \$extension_id"
            url="$DOWNLOAD_BASE/\${extension_id}/download"
            tmp_tar="/tmp/zed_extensions/\${extension_id}.tar"
            mkdir -p "/tmp/zed_extensions/\${extension_id}"
            curl -sSLf "\$url" -o "\$tmp_tar"
            tar -xf "\$tmp_tar" -C "/tmp/zed_extensions/\${extension_id}"
            rm -f "\$tmp_tar"
        fi
    done

    ls -la /tmp/zed_extensions
EOF

# Copy from server to local (macOS Zed extensions path).
LOCAL_ZED_EXT="${HOME}/Library/Application Support/Zed/extensions/installed"
mkdir -p "$LOCAL_ZED_EXT"
rsync -avz --progress "$SERVER:/tmp/zed_extensions/" "$LOCAL_ZED_EXT/"

echo "Extensions updated in $LOCAL_ZED_EXT"
