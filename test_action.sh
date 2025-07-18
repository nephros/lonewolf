# end of book -> new book
#dconf write /apps/games/lonewolf/current/book "'09tcof'"
#dconf write /apps/games/lonewolf/current/pageId "'sect350'"
#
# Combat
#dconf write /apps/games/lonewolf/current/book "''"
#dconf write /apps/games/lonewolf/current/pageId "''"
#
# Puzzle
#dconf write /apps/games/lonewolf/current/book "''"
#dconf write /apps/games/lonewolf/current/pageId "''"

# Dead/dead end:
#dconf write /apps/games/lonewolf/current/book "''"
#dconf write /apps/games/lonewolf/current/pageId "''"

qmlscene -I /usr/share/harbour-lonewolf app/Main.qml
