#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then
  hyprctl keyword monitor "eDP-1,1920x1080,0x0,1"
  hyprctl keyword monitor "HDMI-A-2,1920x1080@60,1920x0,1"

  for ws in {1..10}; do
    hyprctl keyword workspace "$ws,monitor:eDP-1"
  done

  for ws in {11..20}; do
    hyprctl keyword workspace "$ws,monitor:HDMI-A-2"
  done

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  hyprctl keyword monitor "DP-1,1366x768,0x0,1"
  hyprctl keyword monitor "HDMI-A-1,1366x768,1366x0,1"

  for ws in {1..10}; do
    hyprctl keyword workspace "$ws,monitor:DP-1"
  done

  for ws in {11..20}; do
    hyprctl keyword workspace "$ws,monitor:HDMI-A-1"
  done

fi

pidof hyprpaper && killall hyprpaper
pidof dunst && killall dunst
pidof np-applet && killall nm-applet
pidof mpdris2-rs && killall mpdris2-rs
pidof copyq && killall copyq
pidof flameshot && killall flameshot

bash ~/.config/waybar/scripts/run_waybar.sh &
hyprpaper &
dunst &
nm-applet &
mpd &
xdg-portal.sh &
mpdris2-rs &
copyq &
(sleep 2; flameshot) &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &