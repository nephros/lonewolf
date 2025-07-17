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
    function restart() {
        const book = gameState.book
        gameState.clear()
        startBook(book, "")
    }
    function getBookInfo(bid) {
        for (var i=0; i<kaiModel.count; ++i) {
            const b = kaiModel.get(i)
            if (b.book == bid) { return b }
        }
        for (var i=0; i<magnakaiModel.count; ++i) {
            const b = magnakaiModel.get(i)
            if (b.book == bid) { return b }
        }
        for (var i=0; i<grandmasterModel.count; ++i) {
            const b = grandmasterModel.get(i)
            if (b.book == bid) { return b }
        }
        for (var i=0; i<neworderModel.count; ++i) {
            const b = neworderModel.get(i)
            if (b.book == gameState.book) { return b }
        }
        return { "title": "Lone Wolf", "coverColor": "transparent" }
    }

    SilicaFlickable {
        id: flicker
        anchors.fill: parent
        contentHeight: column.height + column.anchors.margins * 2
        //contentWidth: width
        PullDownMenu {
            MenuItem { text: "About"; onClicked: pageStack.push("AboutPage.qml") }
            MenuItem { text: "Restart Book"; enabled: (gameState.pageId != "")
                onClicked: Remorse.popupAction(root, "Restarting Book", function() { root.restart() }, 3000)
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
            PageHeader { id: header; //title: "Lone Wolf"
                Rectangle { anchors.fill: parent; color: "black" }
                Image {
                  source:  (Theme.colorScheme == Theme.DarkOnLight ) ? "header_logo_bow.png" : "header_logo_wob.png"
                  sourceSize.height: 400
                  anchors.fill: parent
                  anchors.verticalCenter: parent.verticalCenter
                  fillMode: Image.PreserveAspectFit
                  smooth: false
                }
            }

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

            SectionHeader { text: "Adventure  Progress" }
            Label { id: gamestateLabel
                visible: gameState.book != "" && gameState.pageId != ""

                anchors.margins: Theme.paddingMedium
                property string bookTitle: ""
                property string bookPage: ""
                text: "“%1”".arg(bookTitle)
                    + (/^sect/.test(gameState.pageId) ? " page %2".arg(bookPage) : "")
                color: Theme.secondaryColor
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.Wrap
                width: parent.width
                onVisibleChanged: {
                  var b = getBookInfo(gameState.book)
                  bookTitle = b.title
                  bookPage  = gameState.pageId.replace(/\D/g,'');
                }
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
            Label { id: quicksaveLabel
                visible: quickSaveState.pageId != ""

                anchors.margins: Theme.paddingMedium
                property string bookTitle: ""
                property string bookPage: ""
                text: "“%1”".arg(bookTitle)
                    + (/^sect/.test(quickSaveState.pageId) ? " page %2".arg(bookPage) : "")
                color: Theme.secondaryColor
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Text.Wrap
                width: parent.width
                onVisibleChanged: {
                  var b = getBookInfo(quickSaveState.book)
                  bookTitle = b.title
                  bookPage  = quickSaveState.pageId.replace(/\D/g,'');
                }
            }
            SectionHeader { text: "UX Options" }
            /*
            TextSwitch {
                text: "Auto-Save on Quit"
                description: "Automatically perform a Quick Save when the app is closed"
                checked: uisettings.saveOnQuit
                onCheckedChanged: uisettings.saveOnQuit = checked
            }
            */
            TextSwitch { id: styleswitch
                text: "Apply text styling"
                description: "Add styling to the book pages for a more authentic look"
                checked: uisettings.styleHtml
                onCheckedChanged: uisettings.styleHtml = checked
            }
            TextSwitch { id: ttsswitch
                text: "Text-To-Speech: Read automatically"
                description: "Start reading each page immediately after it's loaded.\nIf disabled, you can still use the TTS button to hear the page"
                checked: uisettings.autoTts
                onCheckedChanged: uisettings.autoTts = checked
                //visible: mainView.ttsAvailable
                enabled: mainView.ttsAvailable
            }
            Label {
                visible: !ttsswitch.enabled
                text: "Text-to-Speech plugin is not installed."
                wrapMode: Text.Wrap
                x: ttsswitch.x + Theme.paddingMedium *3
            }

            ListModel {
                id: kaiModel
                // colors approx. from collector edition on pape, or from https://shop-magnamund.com/r
                ListElement { book: "01fftd" ; coverColor: "darkblue"   ; title: "Flight from the Dark" }
                ListElement { book: "02fotw" ; coverColor: "cadetblue"  ; title: "Fire on the Water" }
                ListElement { book: "03tcok" ; coverColor: "cyan"       ; title: "The Caverns of Kalte" }
                ListElement { book: "04tcod" ; coverColor: "blueviolet" ; title: "The Chasm of Doom" }
                ListElement { book: "05sots" ; coverColor: "firebrick"  ; title: "Shadow on the Sand" }
            }
            ListModel {
                id: magnakaiModel
                ListElement { book: "06tkot" ; coverColor: "dodgerblue"    ; title: "The Kingdoms of Terror" }
                ListElement { book: "07cd"   ; coverColor: "black"         ; title: "Castle Death" }
                ListElement { book: "08tjoh" ; coverColor: "darkseagreen"  ; title: "The Jungle of Horrors" }
                ListElement { book: "09tcof" ; coverColor: "darksalmon"    ; title: "The Cauldron of Fear" }
                ListElement { book: "10tdot" ; coverColor: "darkslategrey" ; title: "The Dungeons of Torgar" }
                ListElement { book: "11tpot" ; coverColor: "darkorchid"    ; title: "The Prisoners of Time" }
                ListElement { book: "12tmod" ; coverColor: "darkmagenta"   ; title: "The Masters of Darkness" }
            }
            ListModel {
                id: grandmasterModel
                ListElement { book: "13tplor" ; coverColor: "darkseagreen"   ; title: "The Plague Lords of Ruel" }
                ListElement { book: "14tcok"  ; coverColor: "darkorchid"     ; title: "The Captives of Kaag" }
                ListElement { book: "15tdc"   ; coverColor: "darkturquoise"  ; title: "The Darke Crusade" }
                ListElement { book: "16tlov"  ; coverColor: "darkslategrey"  ; title: "The Legacy of Vashna" }
                ListElement { book: "17tdoi"  ; coverColor: "darkkhaki"      ; title: "The Deathlord of Ixia" }
                ListElement { book: "18dotd"  ; coverColor: "crimson"        ; title: "Dawn of the Dragons" }
                ListElement { book: "19wb"    ; coverColor: "peru"           ; title: "Wolf's Bane" }
                ListElement { book: "20tcon"  ; coverColor: "lightsteelblue" ; title: "The Curse of Naar" }

            }
            ListModel {
                id: neworderModel
                ListElement { book: "21votm" ; coverColor: "mediumaquamarine" ; title: "Voyage of the Moonstone" }
                ListElement { book: "22tbos" ; coverColor: "cadetblue"        ; title: "The Buccaneers of Shadaki" }
                ListElement { book: "23mh"   ; coverColor: "coral"            ; title: "Mydnight's Hero" }
                ListElement { book: "24rw"   ; coverColor: "crimson"          ; title: "Rune War" }
                ListElement { book: "25totw" ; coverColor: "steelblue"        ; title: "Trail of the Wolf" }
                ListElement { book: "26tfobm"; coverColor: "goldenrod"        ; title: "The Fall of Blood Mountain" }
                ListElement { book: "27v"    ; coverColor: "indigo"           ; title: "Vampirium" }
                ListElement { book: "28thos" ; coverColor: "yellowgreen"      ; title: "The Hunger of Sejanoz" }
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

