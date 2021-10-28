#!/bin/zsh

function tag(){
	songname=$(basename ${1})
	echo "\nFile: $songname"
	printf "Enter song title: "
	read newTitle
	printf "Enter song artist: "
	read newArtist
	printf "Enter song album: "
	read newAlbum
	printf "Enter song track number: "
	read newTrackNumber
	printf "Enter song year: "
	read newYear
}

function work(){
	songname=$(basename ${1})
	echo "Filename $songname"
	mpv ${1}
	while true
	do
		echo "\n\nFilename $songname"
		printf "Choose an option:\n"
		printf "(s)kip\n(t)ag\n(d)elete\n(q)uit\n"
		read -sk option

		if [ "$option" = "t" ]; then
			tag "${1}"
			break
		elif [ "$option" = "s" ]; then
			break
		elif [ "$option" = "d" ]; then
			printf "Confirm Delete (y/n): "
			read -sk confirmDel
			if [ "$confirmDel" = "y" ]; then
				rm "${1}"
				break
			fi
		elif [ "$option" = "q" ]; then
			rm music_list.txt
			exit
		fi

	done

}

find -type f | grep '[mc]$' > music_list.txt

while read i < music_list.txt
do
	work "$i"
	awk 'NR>1' music_list.txt > new_list.txt
	mv new_list.txt music_list.txt
done

# for i in $(find -type f | grep '[mc]$' | awk '{print "\042"$0"\042"}')
# do
# 	echo $i
# done

rm music_list.txt
