#!/bin/bash

_HOSTNAME="$(hostnamectl --static)"

if [ "${_HOSTNAME}" = "akkihp" ]; then
  hyprctl keyword monitor "eDP-1,1920x1080,0x0,1"

  hyprctl keyword workspace "1,monitor:eDP-1"
  hyprctl keyword workspace "2,monitor:eDP-1"
  hyprctl keyword workspace "3,monitor:eDP-1"
  hyprctl keyword workspace "4,monitor:eDP-1"
  hyprctl keyword workspace "5,monitor:eDP-1"
  hyprctl keyword workspace "6,monitor:eDP-1"
  hyprctl keyword workspace "7,monitor:eDP-1"
  hyprctl keyword workspace "8,monitor:eDP-1"
  hyprctl keyword workspace "9,monitor:eDP-1"
  hyprctl keyword workspace "10,monitor:eDP-1"

  _WAYBAR_FONT_SIZE=14px

elif [ "${_HOSTNAME}" = "ltrcakki" ]; then

  hyprctl keyword monitor "DP-1,1366x768,0x0,1"
  hyprctl keyword monitor "HDMI-A-1,1366x768,1366x0,1"

  hyprctl keyword workspace "1,monitor:DP-1"
  hyprctl keyword workspace "2,monitor:DP-1"
  hyprctl keyword workspace "3,monitor:DP-1"
  hyprctl keyword workspace "4,monitor:DP-1"
  hyprctl keyword workspace "5,monitor:DP-1"
  hyprctl keyword workspace "6,monitor:DP-1"
  hyprctl keyword workspace "7,monitor:DP-1"
  hyprctl keyword workspace "8,monitor:DP-1"
  hyprctl keyword workspace "9,monitor:DP-1"
  hyprctl keyword workspace "10,monitor:DP-1"

  hyprctl keyword workspace "11,monitor:HDMI-A-1"
  hyprctl keyword workspace "12,monitor:HDMI-A-1"
  hyprctl keyword workspace "13,monitor:HDMI-A-1"
  hyprctl keyword workspace "14,monitor:HDMI-A-1"
  hyprctl keyword workspace "15,monitor:HDMI-A-1"
  hyprctl keyword workspace "16,monitor:HDMI-A-1"
  hyprctl keyword workspace "17,monitor:HDMI-A-1"
  hyprctl keyword workspace "18,monitor:HDMI-A-1"
  hyprctl keyword workspace "19,monitor:HDMI-A-1"
  hyprctl keyword workspace "20,monitor:HDMI-A-1"
  
  _WAYBAR_FONT_SIZE=12px

fi

_WAYBAR_FONT_SIZE=${_WAYBAR_FONT_SIZE:-12px} envsubst < ~/.config/waybar/style.css > /tmp/waybar_style.css

pidof waybar && killall waybar
pidof hyprpaper && killall hyprpaper
pidof dunst && killall dunst
pidof np-applet && killall nm-applet
pidof mpdris2-rs && killall mpdris2-rs
pidof copyq && killall copyq

waybar -s "/tmp/waybar_style.css" &
hyprpaper &
dunst &
nm-applet &
mpd &
xdg-portal.sh &
mpdris2-rs &
copyq &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &