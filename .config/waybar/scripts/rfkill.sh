#!/usr/bin/env bash
set -euo pipefail

declare -A ENABLED_ICONS
declare -A DISABLED_ICONS

readonly DEVICE_NAME="$1"
if [ -z "$DEVICE_NAME" ]; then
  echo "No device name provided"
  exit 1
fi

rfkill_devices="$(rfkill --json)"

declare -A device_ids_types
while read -r id type; do
  device_ids_types["$id"]="$type"
done < <(echo "$rfkill_devices" | jq -r '.rfkilldevices[] | "\(.id) \(.type)"')

ENABLED_ICONS=( \
  ["wlan"]="󰤨" \
  ["bluetooth"]="󰂯" \
)
DISABLED_ICONS=( \
  ["wlan"]="󰤭" \
  ["bluetooth"]="󰂲" \
)

rfkill event |
  while read -r event; do
    idx=$(echo "$event" | awk '{print $4}')
    type=$(echo "$event" | awk '{print $6}')
    op=$(echo "$event" | awk '{print $8}')
    soft=$(echo "$event" | awk '{print $10}')
    hard=$(echo "$event" | awk '{print $12}')

    device_name="${device_ids_types[$idx]}"
    if [ "$device_name" == "$DEVICE_NAME" ]; then

      if [ "$op" == "0" ] || [ "$op" == "2" ] || [ "$op" == "3" ] ; then
        # Operation ADD or CHANGE

        if [ "$soft" == "0" ]; then
          # Soft unblock
          printf '%s' "${ENABLED_ICONS[$device_name]}"
        else
          # Soft block
          printf '%s' "${DISABLED_ICONS[$device_name]}"
        fi

        if [ "$hard" == "1" ]; then
          # Hard block
          printf '%s' " "
        fi

      elif [ "$op" == "1" ]; then
        # Operation DELETE

        printf '%s' "${DISABLED_ICONS[$device_name]}"
        printf '%s' " 󰆴"

      fi

      printf ' \n'

    fi

  done
