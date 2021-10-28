#!/bin/zsh

# you can set this to the one you use
TERMINAL=alacritty

file=$(mktemp)

# a small delay is usually required when dealing with xdotool
sleep 0.5s

# copy whatever was selected
xdotool key ctrl+a;
sleep 0.3s
xdotool key ctrl+c;

# put clipboard contents inside a file
copyq selection > $file
# open preferred text editor (vim!)
$TERMINAL -e $EDITOR $file
# when done with editing, copy contents to clipboard
copyq add "$(cat $file)"

copyq select 0

sleep 0.1s

# replace the selection which was just copied
# xdotool key ctrl+v
xdotool key ctrl+a;
sleep 0.3s
xdotool key ctrl+v;

rm $file
