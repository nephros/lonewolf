import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Page {
    id: root


    function startBook(book, pageId) {
        gameState.book = book;
        gameState.pageId = pageId;
        goToBookTab();
    }
    function nuke() {
        gameState.book = "";
        gameState.pageId = "";
        gameState.clear()
    }
    function nukesave() {
        quickSaveState.book = "";
        quickSaveState.pageId = "";
        quickSaveState.clear()
    }
    function restart() {
        const book = gameState.book
        gameState.clear()
        startBook(book, "")
    }

    SilicaFlickable {
        id: flicker
        anchors.fill: parent
        contentHeight: column.height + column.anchors.margins * 2
        //contentWidth: width
        PullDownMenu {
            MenuItem { text: "About"; onClicked: pageStack.push("AboutPage.qml") }
            MenuItem { text: "Delete Quick Save"; enabled: (quickSaveState.pageId != "")
                onClicked: Remorse.popupAction(root, "Deleting Quick Save", function() { root.nukesave() }, 3000)
            }
            MenuItem { text: "Restart Book"; enabled: (gameState.pageId != "")
                onClicked: Remorse.popupAction(root, "Restarting Book", function() { root.restart() }, 3000)
            }
            MenuItem { text: "Reset Book and Progress"
                onClicked: Remorse.popupAction(root, "Progress and Book cleared", function() { root.nuke() }, 3000)
            }
        }
        Column {
            id: column
            spacing: Theme.paddingSmall
            anchors.left: parent.left
            anchors.right: parent.right
            //x: anchors.margins
            //y: anchors.margins
            anchors.margins: Theme.horizontalPageMargin
            //width: (flicker.contentWidth > units.gu(60) ? units.gu(60) : flicker.contentWidth) - anchors.margins * 2
            //anchors.horizontalCenter: parent.horizontalCenter
            PageHeader { id: header; title: "Lone Wolf" }

            Label {
                text: "<p>Lone Wolf is a role-playing book series from the 80s.</p><br>" +
                      "<p>This app lets you play the old adventures, but the text is not updated.  It may refer to things like pencils that assume you are playing with an actual book.  And it relies on the honor system a bit.  Just roll with it.</p><br>" +
                      "<p>If you have any rules questions or encounter an ambiguity, try the <a href='http://www.projectaon.org/en/ReadersHandbook/Home'>Reader's Handbook</a>.</p>"
                color: Theme.highlightColor
                linkColor: Theme.primaryColor
                onLinkActivated: Qt.openUrlExternally(link)
                wrapMode: Text.Wrap
                width: parent.width
            }

            ButtonLayout {
                Button {
                    text: gameState.book == "" && gameState.pageId == "" ? "Start Book 1" : "Continue"
                    onClicked: goToBookTab()
                }
                SecondaryButton {
                    text: "Load Quick Save"
                    enabled: quickSaveState.pageId != ""
                    onClicked: loadQuickSave()
                }
            }
            TextSwitch {
                text: "Auto-Save on Quit"
                description: "Automatically perform a Quick Save when the app is closed"
                checked: uisettings.saveOnQuit
                onCheckedChanged: uisettings.saveOnQuit = checked
            }
            TextSwitch {
                text: "Apply text styling"
                description: "Add styling to the book pages for a more authentic look"
                checked: uisettings.styleHtml
                onCheckedChanged: uisettings.sstyleHtmlaveOnQuit = checked
            }


            ListModel {
                id: kaiModel
                ListElement { book: "01fftd" ; title: "Flight from the Dark" }
                ListElement { book: "02fotw" ; title: "Fire on the Water" }
                ListElement { book: "03tcok" ; title: "The Caverns of Kalte" }
                ListElement { book: "04tcod" ; title: "The Chasm of Doom" }
                ListElement { book: "05sots" ; title: "Shadow on the Sand" }
            }
            ListModel {
                id: magnakaiModel
                ListElement { book: "06tkot" ; title: "The Kingdoms of Terror" }
                ListElement { book: "07cd"   ; title: "Castle Death" }
                ListElement { book: "08tjoh" ; title: "The Jungle of Horrors" }
                ListElement { book: "09tcof" ; title: "The Cauldron of Fear" }
                ListElement { book: "10tdot" ; title: "The Dungeons of Torgar" }
                ListElement { book: "11tpot" ; title: "The Prisoners of Time" }
                ListElement { book: "12tmod" ; title: "The Masters of Darkness" }
            }
            ListModel {
                id: grandmasterModel
                ListElement { book: "13tplor" ; title: "The Plague Lords of Ruel" }
                ListElement { book: "14tcok"  ; title: "The Captives of Kaag" }
                ListElement { book: "15tdc"   ; title: "The Darke Crusade" }
                ListElement { book: "16tlov"  ; title: "The Legacy of Vashna" }
                ListElement { book: "17tdoi"  ; title: "The Deathlord of Ixia" }
                ListElement { book: "18dotd"  ; title: "Dawn of the Dragons" }
                ListElement { book: "19wb"    ; title: "Wolf's Bane" }
                ListElement { book: "20tcon"  ; title: "The Curse of Naar" }

            }
            ListModel {
                id: neworderModel
                ListElement { book: "21votm" ; title: "Voyage of the Moonstone" }
                ListElement { book: "22tbos" ; title: "The Buccaneers of Shadaki" }
                ListElement { book: "23mh"   ; title: "Mydnight's Hero" }
                ListElement { book: "24rw"   ; title: "Rune War" }
                ListElement { book: "25totw" ; title: "Trail of the Wolf" }
                ListElement { book: "26tfobm"; title: "The Fall of Blood Mountain" }
                ListElement { book: "27v"    ; title: "Vampirium" }
                ListElement { book: "28thos" ; title: "The Hunger of Sejanoz" }
            }

            SectionHeader { text: "Available Books" }
            BookList {
                model: kaiModel
                title: "Kai Series"
                description: "Save your country from a looming threat.\nStart here if you've never played before."
                onStartBook: root.startBook(book, "")
                width: parent.width
            }
            BookList {
                model: magnakaiModel
                title: "Magnakai Series"
                description: "Save the realm from the Darklords by collecting the Lorestones of Varetta."
                onStartBook: root.startBook(book, "")
                width: parent.width
                //product: magnakaiProduct
            }
            BookList {
                model: grandmasterModel
                title: "Grandmaster Series"
                description: "Save the world from the Dark God Naar and his minions."
                onStartBook: root.startBook(book, "")
                width: parent.width
                //product: grandmasterProduct
            }
            BookList {
                model: neworderModel
                title: "New Order Series"
                description: "Continue thwarting the forces of evil as one of Lone Wolf's disciples."
                onStartBook: root.startBook(book, "")
                width: parent.width
                //product: neworderProduct
            }
        }
    }
}

