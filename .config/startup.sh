#!/bin/bash

( xrandr | grep --perl-regexp 'HDMI-\d connected' ) && HDMI_CONNECTED=true || HDMI_CONNECTED=false

if $HDMI_CONNECTED; then
    _layout_samsung_main.sh
    _xorg_nvidia_force_composition.sh
fi

# ( pidof dunst || dunst 2>/dev/null >/dev/null ) & disown
# ( bash "$HOME/.config/polybar/launch_polybar.sh" ) & disown
( pidof -x sxhkd || sxhkd 2>/dev/null >/dev/null ) & disown
( pidof flameshot || flameshot 2>/dev/null >/dev/null ) & disown
( pidof mpd || mpd 2>/dev/null >/dev/null ) & disown
( pidof mpDris2 || mpDris2 2>/dev/null >/dev/null ) & disown
( killall nm-applet; nm-applet 2>/dev/null >/dev/null ) & disown
( killall blueman-applet; blueman-applet 2>/dev/null >/dev/null ) & disown
( pidof picom || picom 2>/dev/null >/dev/null ) & disown
( killall copyq; sleep 10 && copyq 2>/dev/null >/dev/null ) & disown

xwallpaper --zoom "$HOME/media/wallpapers/panda-2-1920×1080.jpg" &

wmname LG3D &
