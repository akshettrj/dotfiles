#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then

  _WAYBAR_FONT_SIZE=12px

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  _WAYBAR_FONT_SIZE=10px

fi

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} envsubst < ~/.config/waybar/style.css > /tmp/waybar_style.css

pidof waybar && killall -9 waybar
waybar -c ~/.config/waybar/config.jsonc -s "/tmp/waybar_style.css" &
waybar -c ~/.config/waybar/config_2.jsonc -s "/tmp/waybar_style.css" &
