#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then

  _WAYBAR_FONT_SIZE=13px
  _WAYBAR_ICON_SIZE=15
  _WAYBAR_SEPARATOR_FONT_SIZE=26px

elif [ "${_HOSTNAME}" = "alienrj" ]; then

  _WAYBAR_FONT_SIZE=18px
  _WAYBAR_ICON_SIZE=30
  _WAYBAR_SEPARATOR_FONT_SIZE=34px

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  _WAYBAR_FONT_SIZE=10px
  _WAYBAR_ICON_SIZE=15
  _WAYBAR_SEPARATOR_FONT_SIZE=18px

fi

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} \
_WAYBAR_ICON_SIZE=${_WAYBAR_ICON_SIZE:-15} \
_WAYBAR_SEPARATOR_FONT_SIZE=${_WAYBAR_SEPARATOR_FONT_SIZE:-20px} \
   envsubst < ~/.config/waybar/style.css > /tmp/waybar_style.css

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} \
_WAYBAR_ICON_SIZE=${_WAYBAR_ICON_SIZE:-15} \
_WAYBAR_SEPARATOR_FONT_SIZE=${_WAYBAR_SEPARATOR_FONT_SIZE:-20px} \
   envsubst < ~/.config/waybar/config.json5 > /tmp/waybar_config.json5

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} \
_WAYBAR_ICON_SIZE=${_WAYBAR_ICON_SIZE:-15} \
_WAYBAR_SEPARATOR_FONT_SIZE=${_WAYBAR_SEPARATOR_FONT_SIZE:-20px} \
   envsubst < ~/.config/waybar/config_2.json5 > /tmp/waybar_config_2.json5

pidof waybar && killall -9 waybar
waybar -c "/tmp/waybar_config.json5"   -s "/tmp/waybar_style.css" > /tmp/waybar_main 2>&1 &
waybar -c "/tmp/waybar_config_2.json5" -s "/tmp/waybar_style.css" > /tmp/waybar_second 2>&1 &
