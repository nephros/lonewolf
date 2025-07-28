import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Page {
    id: root

    function startBook(book, pageId) {
        gameState.book = book;
        gameState.pageId = pageId;
        if (pageId == "") uisettings.showHints = true
        goToBookTab();
    }
    function startBookQuestion(book) {
        const b = getBookInfo(book)
        startItem.book       = b.book
        startItem.title      = b.title
        startItem.coverColor = b.coverColor
        startItem.blurb      = b.blurb
        startItem.visible = true
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
            if (b.book == bid) { return b }
        }
        //return { "title": "Lone Wolf", "coverColor": "transparent" }
        // if in doubt, return the first book:
        return kaiModel.get(0)
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

            Label { id: licenselabel
                text: "<p>You have accepted the<br /><a href='https://www.projectaon.org/en/Main/License'>Project AON License</a>.</p>"
                color: Theme.secondaryColor
                linkColor: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                onLinkActivated: Qt.openUrlExternally(link)
                wrapMode: Text.Wrap
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            SectionHeader { text: "Adventure Progress" }
            BackgroundItem { id: startBookItem
                width: parent.width
                height: stateCover.height + stateLabel.height
                onClicked: goToBookTab()
                BookCover { id: stateCover
                    showIndex: false
                    book: gameState.book != "" ? gameState.book : "01fftd"
                    width: parent.width/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    // if we have a game state, we have accepted the license
                    mayDisplay: uisettings.licenseAccepted || (gameState.book != "" && gameState.pageId != "license")
                }
                Label { id: stateLabel
                    anchors.top: stateCover.bottom
                    anchors.horizontalCenter: stateCover.horizontalCenter
                    anchors.margins: Theme.paddingMedium
                    property string bookPage: ""
                    text: gameState.book == "" && gameState.pageId == ""
                         ? "Start Book 1"
                         : "Continue" + (/^sect/.test(gameState.pageId) ? " on page %2".arg(bookPage) : "")
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    //width: parent.width
                    width: stateCover.width
                    onVisibleChanged: {
                      bookPage  = gameState.pageId.replace(/\D/g,'');
                    }
                }
            }
            Item { height: Theme.itemSizeMedium; width: 1 }
            SecondaryButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Load Quick Save"
                enabled: quickSaveState.pageId != ""
                onClicked: loadQuickSave()
            }
            Label { id: quicksaveLabel
                visible: quickSaveState.pageId != ""

                anchors.margins: Theme.paddingMedium
                property string bookTitle: ""
                property string bookPage: ""
                text: "“%1”".arg(bookTitle)
                    + (/^sect/.test(quickSaveState.pageId) ? " page %2".arg(bookPage) : "")
                color: Theme.secondaryColor
                horizontalAlignment: Text.AlignHCenter
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
            Label {
                width: ttsswitch.width
                visible: !ttsswitch.enabled
                text: "Text-to-Speech plugin is not available.\nEither the plugin is not installed, or outdated/incompatible, or the service crashed."
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                x: ttsswitch.x + Theme.paddingMedium *3
            }
            TextSwitch { id: ttsswitch
                text: "Text-To-Speech: Read automatically"
                description: "Start reading each page immediately after it's loaded.\nIf disabled, you can still use the TTS button to hear the page"
                checked: uisettings.autoTts
                onCheckedChanged: uisettings.autoTts = checked
                //visible: mainView.haveTts
                enabled: mainView.haveTts
            }
            Slider {
                width: ttsswitch.width
                visible: mainView.haveTts
                label: "Reading Speed"
                minimumValue: 0
                maximumValue: 20
                stepSize: 1
                valueText: (value < 1) ? "automatic" : ((value < 8) ? "slow" : ((value < 15) ? "medium" : "fast"))
                value: uisettings.ttsSpeed
                onSliderValueChanged: uisettings.ttsSpeed = sliderValue
            }

            ListModel {
                id: kaiModel
                // colors from the borders of the cover image.
                // determined with ImageMagick: `convert cover.jpg -format "\"#%[hex:u.p{4,4}]\"\n" info:`
                ListElement { book: "01fftd" ; coverColor: "#006634" ; title: "Flight from the Dark"
                    blurb: "In Flight from the Dark , you swear revenge. But first you must reach Holmgard to warn the King of the gathering evil. Relentlessly the servants of darkness hunt you across your country and every turn of the page presents a new challenge. Choose your skills and your weapons carefully—for they can help you succeed in the most fantastic and terrifying journey of your life.
                "    }
                ListElement { book: "02fotw" ; coverColor: "#009999" ; title: "Fire on the Water"
                    blurb: "In Fire on the Water , the King has sent you on a desperate journey to retrieve the only power in Magnamund that can save your people: the Sommerswerd, the sword of the sun. Ahead of you lie terrible dangers—ferocious sea-storms, the tunnel of Tarnalin, and the ghostly death-hulks of Vonotar the Traitor. Use your skills wisely—for only you can save your land from the devastation of the Darklords.
                " }
                ListElement { book: "03tcok" ; coverColor: "#0099CB" ; title: "The Caverns of Kalte"
                    blurb: "In The Caverns of Kalte , you must brave the terrible dangers of the ice kingdom in your quest to capture your most hated foe. But be warned! It is a challenge that will test your skill and endurance to the very limit.
                " }
                ListElement { book: "04tcod" ; coverColor: "#000098" ; title: "The Chasm of Doom"
                    blurb: "In The Chasm of Doom , you are sent to recover the missing gold and locate the lost patrol, but you soon discover that it is a mission of direful consequence—for the fate of your country is at stake!
                " }
                ListElement { book: "05sots" ; coverColor: "#CC9900" ; title: "Shadow on the Sand"
                    blurb: "In Shadow on the Sand , you are the quarry of a sinister foe, determined to kill you at all costs. Choose your skills and your weapons carefully. They can help you survive and aid you in the quest for a lost Sommlending treasure—a treasure that contains the secret of your destiny.
                " }
            }

            ListModel {
                id: magnakaiModel
                ListElement { book: "06tkot" ; coverColor: "#999A00" ; title: "The Kingdoms of Terror"
                    blurb: "In The Kingdoms of Terror , you must follow a trail of ancient clues that will take you deep into the hostile Stornlands, where war, treachery, and intrigue will conspire to defeat your quest. Choose your weapons and your skills with care—the future of your country depends on it!
            " }
                ListElement { book: "07cd"   ; coverColor: "#00CC65" ; title: "Castle Death"
                    blurb: "Somewhere deep within Castle Death lies a key to the wisdom of your ancestors. Will you find this key, or will you, like all who have entered before you, succumb to the terror that stalks the dungeons of this nightmare fortress?
            " }
                ListElement { book: "08tjoh" ; coverColor: "#669970" ; title: "The Jungle of Horrors"
                    blurb: "Guided by Lord Paido, warrior-magician of Dessi, you set off across the war-torn lands of Talestria on your vital secret mission. But your quest is soon endangered when your identity is discovered by agents of your mortal enemies—the Darklords of Helgedad. Can you survive the assassins of Gnaag, the armies of Warlord Zegron, and the Chaos-creatures of Agarash the Damned? Will you fall foul of their evil schemes, or will you defeat them and fulfil your destiny?
            " }
                ListElement { book: "09tcof" ; coverColor: "#FE9900" ; title: "The Cauldron of Fear"
                    blurb: "In The Cauldron of Fear , you must stay one step ahead of your foes as you search for the Lorestone in a fantastic metropolis built during the dawn of Magnamund.
            " }
                ListElement { book: "10tdot" ; coverColor: "#FE0000" ; title: "The Dungeons of Torgar"
                    blurb: "In The Dungeons of Torgar , your mission is to recapture the last remaining Lorestones from the clutches of your enemy—the evil Darklord Gnaag. But be warned! Every turn of the page presents a new and deadly challenge as you battle through the depths of a fantastic and terrifying fortress in search of your destiny…or your doom!
            " }
                ListElement { book: "11tpot" ; coverColor: "#808066" ; title: "The Prisoners of Time"
                    blurb: "Somewhere in the supernatural void are the two remaining Lorestones you must find in order to restore the Kai to their former glory. Will you find them, or will you remain forever a prisoner of the void? Your doom or your destiny awaits you in this exciting penultimate episode of the Magnakai quest.
            " }
                ListElement { book: "12tmod" ; coverColor: "#990100" ; title: "The Masters of Darkness"
                    blurb: "In The Masters of Darkness , your mission is to journey to the infernal city of Helgedad, to the very heart of the Darklords’ evil empire. There you must confront Darklord Gnaag, Archlord of the Black City, in a battle that will determine the future of your entire world.
            " }
            }

            ListModel {
                id: grandmasterModel
                ListElement { book: "13tplor" ; coverColor: "#666632" ; title: "The Plague Lords of Ruel"
                    blurb: "In The Plague Lords of Ruel , your mission is to prevent the malevolent Cener Druids of Ruel from releasing a deadly plague virus that will destroy all but their own kind. Of all the warriors of Magnamund only you can thwart their wicked plans—for only you possess the disciplines of a Kai Grand Master.
            " }
                ListElement { book: "14tcok"  ; coverColor: "#670099" ; title: "The Captives of Kaag"
                    blurb: "In The Captives of Kaag , you must venture alone into the black heart of Kaag, to free your friend from the forces which imprison him against his will. Will you succeed? Or will you and Banedon fall victim to the evil power which commands this fortress of nightmares?
            " }
                ListElement { book: "15tdc"   ; coverColor: "#669ACC" ; title: "The Darke Crusade"
                    blurb: "In The Darke Crusade , you must journey through the infernal Hellswamp, trek deep into the forests of northern Nyras and brave the heat of battle. Will you succeed and save your allies? Or will you fall victim to Warlord Magnaarn?
            " }
                ListElement { book: "16tlov"  ; coverColor: "#0033CC" ; title: "The Legacy of Vashna"
                    blurb: "In The Legacy of Vashna , you must locate and defeat the Darklord’s minions before they can complete the resurrection of their master—the most powerful Lord of Evil your world has ever known. Will you succeed in your quest? Or will you and your fragile world perish in the wrath of Vashna?
            " }
                ListElement { book: "17tdoi"  ; coverColor: "#6599FF" ; title: "The Deathlord of Ixia"
                    blurb: "In The Deathlord of Ixia , you must journey to the forbidden city of Xaagon—the seat of Lord Ixiataaga’s dark power—and confront him in a life-or-death battle which will test your Grand Master abilities to the limit. Will you overcome and defeat this terrifying entity? Or will you fall victim to his undead legions and the terrible new power they wield?
            " }
                ListElement { book: "18dotd"  ; coverColor: "#008001" ; title: "Dawn of the Dragons"
                    blurb: "During your long voyage home from a successful quest you discover the Dark God Naar is poised to unleash a horde of fire-breathing dragons upon the Kai Monastery. Will his agents assassinate you en route? Or will you manage to arrive at your monastery in time to take command of the New Order of young Kai warriors in what could be their first and final battle against Naar’s champions of evil?
            " }
                ListElement { book: "19wb"    ; coverColor: "#986665" ; title: "Wolf's Bane"
                    blurb: "In Wolf’s Bane , you must hunt down and destroy your evil alter-ego before it lays waste to your proud reputation and your homeland of Sommerlund. Will you find and defeat this evil mirror-image in time? Or will you fall foul of the Dark God’s plans and be destroyed by your likeness?
            " }
                ListElement { book: "20tcon"  ; coverColor: "#660066" ; title: "The Curse of Naar"
                    blurb: "In The Curse of Naar , you must venture once more through the Shadow Gate and confront the Dark God. Only by finding and retrieving the Moonstone can you hope to save your world from invasion by Naar’s armies of night. In this ultimate Grand Master challenge, your life and the future of your entire world are at stake!
            " }
            }

            ListModel {
                id: neworderModel
                ListElement { book: "21votm" ; coverColor: "#6601FF"  ; title: "Voyage of the Moonstone"
                    blurb: "Armed with the special weapons and skills of a New Order Grand Master, you embark upon a secret voyage to the distant Isle of Lorn. However, your mission quickly becomes a life-and-death struggle when you encounter intrigue and deadly danger en route.
            " }
                ListElement { book: "22tbos" ; coverColor: "#009865"  ; title: "The Buccaneers of Shadaki"
                    blurb: "In The Buccaneers of Shadaki , your quest is to deliver this stone of power to the Shianti who are exiled upon the mystical Isle of Lorn. Will your vital quest succeed, or will you fall foul of the pirates and perils that infest the southern seas of Magnamund?
            " }
                ListElement { book: "23mh"   ; coverColor: "#CC6733"  ; title: "Mydnight's Hero"
                    blurb: "In Mydnight’s Hero , your quest is to voyage to Sheasu and track down Prince Karvas in the fabled city of Mydnight. Once found you must persuade him to return with you to Siyen without delay. You have only 50 days in which to complete this challenging quest or Siyen will be enslaved by the tyrannical Sadanzo and his brutal followers.
            " }
                ListElement { book: "24rw"   ; coverColor: "#336799"  ; title: "Rune War"
                    blurb: "In Rune War , your task is to infiltrate Skull-Tor, Lord Vandyan’s stronghold, and destroy the ancient runes from which he draws his evil power. Can you succeed in your vital mission…or will you fall foul of the traps and terrors that guard the warlord’s mighty fortress?
            " }
                ListElement { book: "25totw" ; coverColor: "#993365"  ; title: "Trail of the Wolf"
                    blurb: "In Trail of the Wolf , you must venture alone into the dreaded stronghold of Gazad Helkona to find and free your leader. Can you succeed in your vital mission…or will you fall foul of the horrors that lurk within this Darklands city-fortress?
            " }
                ListElement { book: "26tfobm"; coverColor: "#996533"  ; title: "The Fall of Blood Mountain"
                    blurb: "In The Fall of Blood Mountain , you must journey to the fabulous subterranean kingdom of the dwarves and attempt to save your ancient allies from the wrath of the Shom’zaa. Will you succeed in your mission or will you succumb to the terrible powers of this ancient champion of Evil?
            " }
                ListElement { book: "27v"    ; coverColor: "#CC0033"  ; title: "Vampirium"
                    blurb: "In Vampirium , you must venture into the hostile land of Bhanar and snatch the Claw from the clutches of the evil Autarch Sejanoz. Can you deliver the Claw safely to the Elder Magi…or will you be destroyed by the terrifying wrath of the vampire lord Sejanoz?
            " }
                ListElement { book: "28thos" ; coverColor: "#988098"  ; title: "The Hunger of Sejanoz"
                    blurb: "In The Hunger of Sejanoz , your mission is to escort the aged emperor and his entourage safely across the Great Lissan Plain to Tazhan. Will you succeed in your perilous task…or will you and your charges fall victim to the merciless forces of the Autarch?
            " }
                // was missing, not fully supported
                ListElement { book: "29tsoc" ; coverColor: "cadetblue" ; title: "The Storms of Chai"
                    blurb: "In The Storms of Chai , your mission is one of seven that Kai Supreme Master Lone Wolf has initiated to turn back this unprecedented tide of evil before it engulfs all the goodly nations of Magnamund forever.
            " }
            }

            SectionHeader { text: "Available Books" }
            BookList {
                model: kaiModel
                title: "Kai Series"
                description: "Save your country from a looming threat.\nStart here if you've never played before."
                onStartBook: root.startBookQuestion(book)
                width: parent.width
            }
            BookList {
                model: magnakaiModel
                title: "Magnakai Series"
                description: "Save the realm from the Darklords by collecting the Lorestones of Varetta."
                onStartBook: root.startBookQuestion(book)
                width: parent.width
                //product: magnakaiProduct
            }
            BookList {
                model: grandmasterModel
                title: "Grandmaster Series"
                description: "Save the world from the Dark God Naar and his minions."
                onStartBook: root.startBookQuestion(book)
                width: parent.width
                //product: grandmasterProduct
            }
            BookList {
                model: neworderModel
                title: "New Order Series"
                description: "Continue thwarting the forces of evil as one of Lone Wolf's disciples."
                onStartBook: root.startBookQuestion(book)
                width: parent.width
                //product: neworderProduct
            }
        }
    }
    BackgroundItem { id: startItem
        property string book
        property string title
        property string coverColor
        property string blurb
        property bool resume: false
        clip: true
        visible: false
        anchors.fill: parent
        anchors.centerIn: parent

        onClicked:  { visible = false }
        Rectangle {
            color: Theme.overlayBackgroundColor
            opacity: Theme.opacityOverlay
            anchors.fill: parent
            anchors.centerIn: parent
        }
        BookCover { id: bc
            book: startItem.book
            showIndex: false
            width: parent.width
            anchors.centerIn: parent
            smooth: true
        }
        Label { id: blurbLabel
            anchors.left:  parent.left
            anchors.right: parent.right
            anchors.top:   parent.top
            anchors.topMargin: (Screen.hasCutouts && (Screen.topCutout.height > 0) && isPortrait)
                        ? Screen.topCutout.height
                        : 0
            anchors.bottom: bc.top
            anchors.bottomMargin: Theme.paddingSmall
            text: startItem.blurb
            color: Theme.highlightFromColor(startItem.coverColor, Theme.colorScheme )
            minimumPixelSize: Theme.fontSizeTiny
            //font.pixelSize: Theme.fontSizeSmall
            fontSizeMode: Text.VerticalFit
            verticalAlignment:  Text.AlignBottom
            wrapMode: Text.WordWrap
            truncationMode: TruncationMode.Fade
        }
        Item { id: placer
            anchors.left:  parent.left
            anchors.right: parent.right
            anchors.top: bc.bottom
            anchors.bottom: parent.bottom
        }
        Button { anchors.centerIn: placer
            text: "%1 “%2”".arg( startItem.resume ? "Continue" : "Play" ).arg(startItem.title)
            onClicked:  { startItem.visible = false; root.startBook(startItem.book, "") }
            color: Theme.highlightFromColor(startItem.coverColor, Theme.colorScheme )
        }
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
