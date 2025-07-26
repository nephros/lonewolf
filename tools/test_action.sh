#!/bin/sh

case $1 in
	starterpack-kai)
		if [ -e 01fftd_starterpack.dconf ]; then
		    cat 01fftd_starterpack.dconf | dconf load /apps/games/lonewolf/current/
		fi
	;;
	starterpack-magnakai)
		if [ -e 11tpot_magnakai.dconf ]; then
		    cat 11tpot_magnakai.dconf | dconf load /apps/games/lonewolf/current/
		fi
	;;
	starterpack-gm)
		if [ -e 21votm_starterpack.dconf ]; then
		    cat 21votm_starterpack.dconf | dconf load /apps/games/lonewolf/current/
		fi
	;;
		finished)
		# end of book -> new book
		dconf write /apps/games/lonewolf/current/book "'09tcof'"
		dconf write /apps/games/lonewolf/current/pageId "'sect350'"
	;;
	combat)
		# Combat
		dconf write /apps/games/lonewolf/current/book "'10tdot'"
		dconf write /apps/games/lonewolf/current/pageId "'sect2'"
	;;
	puzzle)
		# Puzzle
		dconf write /apps/games/lonewolf/current/book "'09tcof'"
		dconf write /apps/games/lonewolf/current/pageId "'sect204'"
		printf 'The answer to this riddle is:\n\t50\n'
		sleep 5
	;;
	harbour-screenshot-1)
		# Puzzle
		dconf write /apps/games/lonewolf/current/book "'04tcod'"
		dconf write /apps/games/lonewolf/current/pageId "'sect273'"
		dconf write /apps/games/lonewolf/current/endurance 28
		dconf write /apps/games/lonewolf/current/gold 50
	;;
	harbour-screenshot-2)
		# Puzzle
		dconf write /apps/games/lonewolf/current/book "'02fotw'"
		dconf write /apps/games/lonewolf/current/pageId "'sect1'"
		dconf write /apps/games/lonewolf/current/endurance 26
		dconf write /apps/games/lonewolf/current/gold 9
	;;
	dead)
		# Dead/dead end:
		dconf write /apps/games/lonewolf/current/book "'10tdot'"
		#dconf write /apps/games/lonewolf/current/pageId "'sect10'"
		dconf write /apps/games/lonewolf/current/pageId "'sect41'"
		echo "use the option leading to sect 10!"
	;;
	CLEARALL)
		rm -r ~/.cache/QtProject/QtQmlViewer/*
		dconf reset -f  /apps/games/lonewolf/
	;;
	*)
		printf 'USAGE: %s [starterpack-NNNNN|finished|combat|puzzle|dead|harbour-screenshot-N|CLEARALL]\n'
		printf '\tScreenshot IDs (N): 1 2\n\tBooks (NNNN): kai magnakai gm\n'
		exit 1
	;;
esac

qmlscene -I /usr/share/harbour-lonewolf app/Main.qml
