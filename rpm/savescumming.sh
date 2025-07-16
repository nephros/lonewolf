#!/bin/sh

DCONF_PATH=/apps/games/lonewolf/current/
SAVE_PATH=~/.cache
SAVE_PREFIX=lonewolf-save
LATEST_FILENAME=${SAVE_PREFIX}-latest.dconf

function save_game() {
	usure
	dconf dump $DCONF_PATH > $SAVE_PATH/$SAVE_PREFIX-$(date +"%Y%m%d_%H%M%S").dconf
	ln -sf $SAVE_PATH/$SAVE_PREFIX-$(date +"%Y%m%d_%H%M%S").dconf $SAVE_PATH/$LATEST_FILENAME
}

function restore_game() {
	usure
	if [ x"" = x"$1" ]; then
		cat $SAVE_PATH/$LATEST_FILENAME | dconf load $DCONF_PATH
	elif [ -r "$2" ]; then
		cat "$2" | dconf load $DCONF_PATH
	fi
	#dconf write ${DCONF_PATH}notes "\"\'A cheat, a thief, a liar!\'\""
}

function usure() {
	ok=$((100 + $RANDOM % 100))
	printf 'These are the actions of a coward and not worthy of a Kai Lord and Hero of Magnamund!\nAre you sure? (type %s to continue) ' $ok
	read ans
	if [ x"$ok" = x"$ans" ]; then
		printf "\nYou are a cheat, a thief, a liar! The very air around you reeks of deceit.\n
You're scum. Plain and simple.\nA weasel, a con artist, a liar of the highest order.\nThere's no depth to which you won't sink, no boundary you won't cross.
You'd steal from orphans, sell out your own kin, even betray yourself if it meant gaining some small advantage.

The world doesn't need snakes like you slithering through its cracks.\n
Well, it may have worked this time, but let me tell you something: it won't work forever.
"

	else
		printf '\nYou decide to act honourably and refrain from cheating. If you wish, you can note this on your ACTION CHART.\n'
		exit 0
	fi
}

function usage() {
	printf 'Usage:\t%s save\n' $0
	printf '\t%s restore\n' $0
	printf '\t%s restore FILENAME\n\n' $0
	printf '\t%s restore FILENAME\n\n' $0
}

if [ x"" = "$1" ]; then
	usage
	exit 1
else
	case $1 in
	save) save_game ;;
	restore) restore_game $2;;
	*)
		usage
		exit 1
	esac
fi

