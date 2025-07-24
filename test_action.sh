#!/bin/sh

case $1 in
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
		printf 'USAGE: %s [finished|combat|puzzle|dead|CLEARALL]\n\n'
		exit 1
	;;
esac

qmlscene -I /usr/share/harbour-lonewolf app/Main.qml
