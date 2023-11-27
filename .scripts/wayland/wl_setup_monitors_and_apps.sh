#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then
  hyprctl keyword monitor "HDMI-A-1,1366x768@70,0x0,1"
  hyprctl keyword monitor "eDP-1,1920x1080@144,1366x0,1"

  for ws in {1..10}; do
    hyprctl keyword workspace "$ws,monitor:eDP-1" &
  done

  for ws in {11..20}; do
    hyprctl keyword workspace "$ws,monitor:HDMI-A-1" &
  done

elif [ "${_HOSTNAME}" = "alienrj" ]; then

  hyprctl keyword monitor "eDP-1,2560x1600@165,0x0,1,bitdepth,10"
  hyprctl setcursor adwait-dark 20

  for ws in {1..10}; do
    hyprctl keyword workspace "$ws,monitor:eDP-1" &
  done


elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  # hyprctl keyword monitor "DP-1,1366x768,0x0,1"
  # hyprctl keyword monitor "HDMI-A-1,1366x768,1366x0,1"
  hyprctl keyword monitor "HDMI-A-1,1920x1080,0x0,1"
  hyprctl keyword monitor "DP-1,1366x768,1920x312,1"

  # for ws in {1..10}; do
  #   hyprctl keyword workspace "$ws,monitor:DP-1" &
  # done

  # for ws in {11..20}; do
  #   hyprctl keyword workspace "$ws,monitor:HDMI-A-1" &
  # done
  for ws in {1..10}; do
    hyprctl keyword workspace "$ws,monitor:HDMI-A-1" &
  done

  for ws in {11..20}; do
    hyprctl keyword workspace "$ws,monitor:DP-1" &
  done

fi

pidof hyprpaper && killall -9 hyprpaper
bash ~/.config/dunst/start_dunst &
pidof np-applet && killall -9 nm-applet
# pidof mpdris2-rs && killall mpdris2-rs
pidof copyq && killall -9 copyq
# pidof flameshot && killall -9 flameshot

bash ~/.config/waybar/scripts/run_waybar.sh &
hyprpaper &
nm-applet &
mpd &
xdg-portal.sh &
# mpdris2-rs &
copyq &
# (sleep 5; flameshot) &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
