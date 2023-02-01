#!/bin/bash

killall -9 polybar >/dev/null 2>&1

( xrandr | grep --perl-regexp 'HDMI-\d connected' ) && HDMI_CONNECTED=true || HDMI_CONNECTED=false

_WIFI_INTERFACE="$(polybar_wifi_interface)"
_LAN_INTERFACE="$(polybar_lan_interface)"
_HOSTNAME="$(hostnamectl --static)"

_FONT_0="JetBrainsMono NF:size=12:antialias=true;hinting=true"
_FONT_1="Noto Color Emoji:scale=10:antialias=true;hinting=false"

if [ "${_HOSTNAME}" = "ltrcakki" ]; then
    _FONT_0="JetBrainsMono NF:size=9:antialias=true;hinting=true"
    _FONT_1="Noto Color Emoji:scale=11:antialias=true;hinting=false"
fi

if $HDMI_CONNECTED; then
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
    FONT_0=${_FONT_0} \
    FONT_1=${_FONT_1} \
        polybar dp-base & disown
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
    FONT_0=${_FONT_0} \
    FONT_1=${_FONT_1} \
        polybar hdmi-tray & disown
else
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
    FONT_0=${_FONT_0} \
    FONT_1=${_FONT_1} \
        polybar dp-tray & disown
fi
