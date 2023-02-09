#!/bin/bash

( xrandr | grep "HDMI-0 connected" ) && HDMI_CONNECTED=true || HDMI_CONNECTED=false

if $HDMI_CONNECTED; then
    _layout_samsung_main.sh
    _xorg_nvidia_force_composition.sh
fi


_check_and_disown() {
    ( pidof "$1" || "$1" >/dev/null 2>&1 ) & disown
}

_sleep_and_disown() {
    ( killall "$1"; sleep 10 && "$1" >/dev/null 2>&1 ) & disown
}

_check_and_disown dunst
_check_and_disown flameshot
_check_and_disown mpd
_check_and_disown mpDris2
_check_and_disown nm-applet
_check_and_disown blueman-applet
_check_and_disown picom

_sleep_and_disown copyq

xwallpaper --zoom "$HOME/media/wallpapers/power_red.jpg" &

wmname LG3D &
