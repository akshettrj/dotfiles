#!/bin/bash

killall -9 polybar

( xrandr | grep "HDMI-0 connected" ) && HDMI_CONNECTED=true || HDMI_CONNECTED=false

_WIFI_INTERFACE="$(polybar_wifi_interface)"
_LAN_INTERFACE="$(polybar_lan_interface)"

if $HDMI_CONNECTED; then
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
        polybar dp-base & disown
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
        polybar hdmi-tray & disown
else
    WIFI_INTERFACE=${_WIFI_INTERFACE} \
    LAN_INTERFACE=${_LAN_INTERFACE} \
        polybar dp-tray & disown
fi
