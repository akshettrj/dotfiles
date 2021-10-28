#!/bin/sh

# Getting all the files to be tagged
for musicFile in $1/*
do
	# Ignore if already has metadata
	(id3 -2 "$musicFile" | grep 'none found' 2>/dev/null 1>/dev/null) || continue

	#Ignore if its not a music file
	[ $(xdg-mime query filetype "$musicFile") == "video/webm" ] || [ $(xdg-mime query filetype "$musicFile") == "video/mp4" ] || continue

	echo "Current File: $musicFile"

	read -p "Enter the title: " title
	id3 -2 -t "$title" "$musicFile"

	read -p "Enter the artist: " artist
	id3 -2 -a "$artist" "$musicFile"

	read -p "Enter the album: " album 
	id3 -2 -l "$album" "$musicFile"

	read -p "Enter the trackNumber: " trackNumber
	id3 -2 -n "$trackNumber" "$musicFile"

	echo ""

done

echo "All the tagging done"
