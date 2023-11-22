#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then

  _WAYBAR_FONT_SIZE=12px
  _WAYBAR_SEPARATOR_FONT_SIZE=26px

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  _WAYBAR_FONT_SIZE=10px
  _WAYBAR_SEPARATOR_FONT_SIZE=18px

fi

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} \
_WAYBAR_SEPARATOR_FONT_SIZE=${_WAYBAR_SEPARATOR_FONT_SIZE:-20px} \
   envsubst < ~/.config/waybar/style.css > /tmp/waybar_style.css

pidof waybar && killall -9 waybar
waybar -c ~/.config/waybar/config.jsonc -s "/tmp/waybar_style.css" > /tmp/waybar_main 2>&1 &
waybar -c ~/.config/waybar/config_2.jsonc -s "/tmp/waybar_style.css" > /tmp/waybar_second 2>&1 &
