#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then

  BEMENU_FONT_SIZE="14"

elif [ "${_HOSTNAME}" = "alienrj" ]; then

  BEMENU_FONT_SIZE="22"

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  BEMENU_FONT_SIZE="14"

fi

exec /usr/bin/bemenu-run --hp "$((BEMENU_FONT_SIZE - 4))" -H "$((BEMENU_FONT_SIZE + 20))" --cw 2 --ch "$((BEMENU_FONT_SIZE + 8))" --tf "#268bd2" --hf "#268bd2" --hb "#444444" --tb "#444444" -p "Run:" --fn "Iosevka NF ${BEMENU_FONT_SIZE:-14}" --no-cursor
