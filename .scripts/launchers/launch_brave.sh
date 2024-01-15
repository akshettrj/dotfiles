#!/bin/sh

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then

  BRAVE_SCALING_FACTOR="1"

elif [ "${_HOSTNAME}" = "alienrj" ]; then

  BRAVE_SCALING_FACTOR="1.3"

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  BRAVE_SCALING_FACTOR="0.85"

fi

exec brave --force-device-scale-factor="$BRAVE_SCALING_FACTOR" "$@"
