import QtQuick 2.4
import QtFeedback 5.0
import Sailfish.Silica 1.0
import Sailfish.Gallery 1.0 as Gallery
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import Sailfish.WebView.Popups 1.0
import Lonewolf 1.0

WebViewPage {
    id: root

    property var you
    property bool canDoBackAction: false
    property bool firstView: true
    //readonly property product: bookProduct()

    backgroundColor: mainView.nightModeEnabled
         ? "black"
         : Theme.highlightDimmerFromColor("#333300", Theme.colorScheme)


    onStatusChanged: {
        if ((root.status == PageStatus.Active) && (pageStack.nextPage() == null)) {
            var cp = pageStack.pushAttached(chartPage)
        }
        /* TTS: on first load, play something so the daemon/service is ready */
        if ((root.status == PageStatus.Activating) && firstView) {
            firstView = false
            if (mainView.ttsAvailable) {
                if (uisettings.autoTts) {
                    mainView.ttsPlay(mainView.bookTitle)
                } else {
                    mainView.ttsPlay("---")
                }
            }
        }
    }
    signal showChartPage
    onShowChartPage: {
        if (pageStack.nextPage() == null) {
            var cp = pageStack.pushAttached(chartPage)
            cp.completed.connect(pageStack.navigateForward())
        } else {
            pageStack.navigateForward()
        }
    }
    ChartPage {
        id: chartPage
        objectName: "chart"
        you: root.you
    }

    Component.onCompleted: {
        if (book.progress < 100) {
            book.downloadBook();
            pageView.pageId = "license";
            book.inBackMatter = false;
            downloadCover.visible = false;
        }
        canDoBackAction = true;
        // Debug some engine events:
        //WebEngine.onRecvObserve.connect(function(message, data) {
        //    console.log("Engine event contents: ", message, JSON.stringify(data));
        //})
    }

    ThemeEffect { id: haptics; effect: ThemeEffect.PressWeak }
    SilicaFlickable { id: flickable
        anchors.fill: parent
        //contentHeight: header.height + endurancebar.height + viewBorder.height + navigation.height
        //interactive: false
        //pressDelay: 0
        //property bool wvHadFocus: pageView.focus
        //property bool wvCanFocus: (!moving && !dragging && !dragging)
        //onWvCanFocusChanged: {
        //    if (wvCanFocus) { wvHadFocus = pageView.focus; pageView.focus = false }
        //    else { if (wvHadFocus) pageView.focus = true }
        //}
        PullDownMenu {
            visible: book.progress == 100
            MenuItem {
                id: quickSave
                //icon.source: "save"
                text: "Quick Save"
                enabled: !book.inBackMatter && mainView.endurance > 0
                onClicked: {
                    if (quickSaveState.pageId == "") {
                        var dlg = pageStack.push(saveDialog);
                        dlg.done.connect(function() {
                          Remorse.popupAction(root, "Saved", function() { you.copyTo(quickSaveState); } )
                        })
                    } else {
                        Remorse.popupAction(root, "Saved", function() { you.copyTo(quickSaveState); } )
                    }
                }
            }
            MenuItem {
                id: backAction
                text: book.inBackMatter ? "Back" : "Back to Menu"
                enabled: canDoBackAction
                onClicked: {
                    if (book.inBackMatter) {
                        pageView.pageId = you.pageId; // go back to saved place
                        book.inBackMatter = false;
                    } else {
                        popBookTab();
                    }
                }
            }
            /*
            MenuItem {
                id: actionChart
                //icon.source: "note"
                text: "Action Chart"
                onClicked: showChartPage()
            }
            */
            /*
            MenuItem {
                id: mapAction
                //icon.source: "location"
                text: "Map"
                //onClicked: pageView.pageId = "map"
                onClicked: showMap()
            }
            */
        }

    PageHeader { id: header
        description: book.pageTitle
        title: mainView.bookTitle
        opacity: mainView.nightModeEnabled ? 0.8 : 1.0
        BackgroundItem {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.extraContent.left
            anchors.leftMargin: Theme.paddingLarge
            width: Theme.iconSizeMedium
            height: Theme.iconSizeMedium
            Image {
                anchors.centerIn: parent
                anchors.fill: parent
                source:"./icon-m-windrose.svg"
                cache: true
            }
            visible: !book.inBackMatter && (mainView.endurance > 0)
            onClicked: root.showMap()
        }
    }

    Rectangle {
        id: endurancebar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: Math.max(goldrow.height, endurancerow.height) + Theme.paddingSmall
        color:  mainView.nightModeEnabled ? "black" : Theme.highlightDimmerFromColor(book.bgColor, Theme.colorScheme)

        Row { id: goldrow
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingLarge
            IconButton {
                anchors.margins: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-splus-add"
                enabled: mainView.gold < 50
                onClicked: {
                    haptics.play();
                    adjustGold(1)
                }
            }
            Label {
                text: "%1 Crowns".arg(mainView.gold)
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.SmallCaps
                color: (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                truncationMode: TruncationMode.Fade
            }
            IconButton {
                anchors.margins: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-splus-remove"
                enabled: mainView.gold > 0
                onClicked: {
                    haptics.play();
                    adjustGold(-1)
                }
            }
        }

        Row { id: endurancerow
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge
            IconButton {
                anchors.margins: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-splus-add"
                enabled: mainView.endurance < mainView.maxendurance
                onClicked: {
                    haptics.play();
                    adjustEndurance(1)
                }
            }
            Label {
                text: "%1 Endurance".arg(mainView.endurance)
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.SmallCaps
                color: (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                truncationMode: TruncationMode.Fade
            }
            IconButton {
                anchors.margins: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-splus-remove"
                enabled: mainView.endurance > 0
                onClicked: {
                    haptics.play();
                    adjustEndurance(-1)
                }
            }
        }
    }

    Book {
        id: book
        dir: Qt.resolvedUrl(".")
        filename: you.book ? you.book : "01fftd"
        pageId: pageView.pageId

        bgColor:   mainView.nightModeEnabled ? "black" : "bisque"
        textColor: mainView.nightModeEnabled ? "#8E8E93" : "#333300"
        linkColor:  Theme.highlightFromColor("bisque", (mainView.nightModeEnabled ? Theme.DarkOnLight: Theme.lightOnDark))

        onDirChanged: console.debug("Book dir:", dir, "Cache dir:", cacheDir)

        property bool inBackMatter: false

        onPageContentChanged: {
            if (pageId == "" && pageView.pageId != "")
                return; // on startup we get this fake-out...
            var content = pageContent;
            if (pageId != "title" && (pageType == "backmatter" || pageType == "deadend")) {
                inBackMatter = true;
            } else if (pageId == "map") {
                showMap()
            } else if (!inBackMatter) {
                you.pageId = pageId; // save place
            }
            var newstyle
            if (uisettings.styleHtml) {
                newstyle=[
                    '<style>* { font-family: lone-wolf, Souvenir, "ITC Souvenir", AG_Souvenir, "Linux Biolinum", Garamond, Georgia, "Times New Roman", Times, serif;}</style>',
                    '<style> .actionlink { border-bottom: 1px dashed #212121; }</style>',
                    '<style> .pagelink { border-bottom: 1px solid #212121; }</style>',
                    '<style> .attribute { font-variant-caps: small-caps; }</style>',
                    '<style> .footnote { font-style: italic; }</style>',
                    '<style> .dedication { font-style: italic; font-weight: bold; text-align: center; margin-left: auto; margin-right: auto; }</style>',
                    '<style> .sound { font-style: italic; }</style>',
                    '<style> dt { font-weight: bold; }</style>',
                    '<style> figure { margin-left: auto; margin-right: auto; }</style>',
                    '<style> figcaption { font-style: italic; }</style>',
                    '<style> quote:before { content: \'“\'; }</style>',
                    '<style> quote:after { content: \'”\'; }</style>',
                    ].join('\n')
            } else {
                newstyle=[
                    '<style> .actionlink { border-bottom: 1px dashed #212121; }</style>',
                    '<style> .pagelink { border-bottom: 1px solid #212121; }</style>',
                    ].join('\n')
            }
            const newcontent = content.replace('</head>', newstyle + '\n' + '</head>')
            pageView.loadHtml(newcontent, Qt.resolvedUrl(book.cacheDir) + "/");
            //console.log("DEBUG page:", newcontent);
        }
    }

    Rectangle { id: viewBorder
        border.color: book.bgColor
        border.width: Theme.horizontalPageMargin
        color: "transparent"
        anchors.centerIn: pageView
        width: pageView.width + Theme.horizontalPageMargin*2
        height: pageView.height + Theme.horizontalPageMargin*2
    }

    WebView {
        id: pageView
        property string pageId: you.pageId
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: endurancebar.bottom
        anchors.bottom: navigation.top
        anchors.margins: Theme.horizontalPageMargin

        canShowSelectionMarkers: false
        chromeGestureEnabled: false
        //onTitleChanged: console.debug("Webview title:", title)
        onRecvAsyncMessage: function(message, data) {
            //console.log("Async Message: ", message, JSON.stringify(data));
            if (message == "embed:alert") {
                handleUserClick(data.text)
            }
        }
        onLoadedChanged: { // text-to-speech
            if (loaded) {
                if (mainView.ttsAvailable) {
                    if (visible) {
                        if (uisettings.autoTts && (book.nextPageId != "") && !book.inBackMatter) { pageView.readText() }
                    }
                }
            }
        }
        function handleUserClick(text) {
            if (text == "random") {
                random.visible = true
            } else if (text == "action") {
                haptics.play()
                root.showChartPage()
            } else if (text == "map") {
                showMap()
            } else if (text.indexOf("combat,") == 0) {
                haptics.play(ThemeEffect.PressStrong);
                //combat.props = text;
                //combat.visible = true;
                pageStack.push(combatPage, { props: text, you: root.you })
            } else if (text.indexOf("external,") == 0) {
                Qt.openUrlExternally(text.split(',')[1]);
            } else if (text.indexOf("puzzle-page,") == 0) {
                //puzzle.answers = text.split(',')[1];
                //puzzle.visible = true;
                var dlg = pageStack.push(puzzlePage, { answers: text.split(',')[1], you: root.you })
                dlg.done.connect(function() { if (dlg.newpage != "not set") pageView.pageId = dlg.newpage })
            } else if (text.indexOf("book,") == 0) {
                haptics.play();
                you.book = text.split(',')[2];
                pageView.pageId = "";
                goToBookTab();
            } else {
                haptics.play();
                pageView.pageId = text;
            }
            console.debug("Executed alert action:", text)
        }

        function readText() { 
            runJavaScript("
                var pageText = document.body.textContent;
                if (pageText) { return pageText } else { return null};
            ",
            function(result) {
                   //console.log("Document text is", result)
                   if (result != "empty") mainView.ttsPlay(result)
            }
            );
        }

        Connections {
            target: WebEngineSettings
            onPixelRatioChanged: uisettings.font = WebEngineSettings.pixelRatio
        }
        Component.onCompleted: {
            WebEngineSettings.pixelRatio = Math.ceil(uisettings.font)
            WebEngineSettings.autoLoadImages = true
            WebEngineSettings.javascriptEnabled = true // <-- This apparently does not work, but the following does:
            WebEngineSettings.setPreference("javascript.enabled", true, WebEngineSettings.BoolPref)

            //WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.disable_cors_checks", false, WebEngineSettings.BoolPref)
        }

        popupProvider: PopupProvider {
            alertPopup: { "type": "item", "component": dummyAlertPopup }
        }
    }

    Item {
        id: navigation
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: (previous.visible || next.visible || licenseButton.visible)
                  ? Math.max (previous.height, plusminus.height) + Theme.paddingMedium : 0
        //color: Theme.highlightDimmerColor

        IconButton {
            id: previous
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingSmall
                //height: parent.height - Theme.paddingSmall
                //width: height
                icon.source: "image://theme/icon-m-previous"
                enabled: book.prevPageId != ""
                onClicked: pageView.pageId = book.prevPageId;
            }
            IconButton {
                id: next
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingSmall
                //height: parent.height - Theme.paddingSmall
                //width: height
                icon.source: "image://theme/icon-m-next"
                enabled: book.nextPageId != ""
                onClicked: pageView.pageId = book.nextPageId
            }

            Row { id: plusminus
                visible: !licenseButton.visible
                anchors.centerIn: parent
                spacing: Theme.paddingMedium
                IconButton {
                    icon.source: "image://theme/icon-splus-remove"
                    onClicked: WebEngineSettings.pixelRatio-=0.5
                }
                IconButton {
                    icon.source: "image://theme/icon-m-font-size?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                    onClicked: WebEngineSettings.pixelRatio = Theme.dp(1)
                }
                IconButton { id: textplus
                    icon.source: "image://theme/icon-splus-add"
                    onClicked: WebEngineSettings.pixelRatio+=0.5
                }
            }

            IconButton { id: readbtn
                icon.source: mainView.ttsSpeaking
                    ? "image://theme/icon-m-speaker-on?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                    : "image://theme/icon-m-speaker?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                highlighted: down || mainView.ttsSpeaking
                onClicked: mainView.ttsSpeaking ?  mainView.ttsStop() : pageView.readText()
                visible: mainView.ttsAvailable && !licenseButton.visible
                anchors.left: previous.right
                anchors.right: plusminus.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingLarge
            }


            IconButton { id: nightmode
                icon.source: "image://theme/icon-m-light-contrast?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                onClicked: mainView.nightModeEnabled = !mainView.nightModeEnabled
                visible: !licenseButton.visible
                anchors.right: next.left
                anchors.left: plusminus.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingLarge
            }

            SecondaryButton {
                id: licenseButton
                text: "Accept"
                //color: theme.palette.normal.positive
                visible: book.progress < 100
                anchors.centerIn: parent
                onClicked: {
                    cancelDownloadButton.visible = true; // can't actually cancel before this (we download xml synchronously)
                    progressBar.indeterminate = false;
                    downloadCover.visible = true;
                    pageView.pageId = "";
                    book.downloadImages();
                }
            }
        }
    }

    /* Our dummy popup thing never gets deleted. See https://github.com/sailfishos/sailfish-components-webview/issues/179
     *  So collect them and destroy from time to time:
    */
    property int popupCount: popupRegistry.length
    property var popupRegistry: []
    onPopupCountChanged: {
        //console.debug("popups:", popupCount)
        if (popupRegistry.length > 50) {
            console.debug("Cleaning up popups")
            var tmp = popupRegistry
            for (var i = 0; i < popupRegistry.length-1; ++i) {
                tmp[i].destroy()
            }
            popupRegistry = tmp
        }
    }

    Component { id: dummyAlertPopup; AlertPopupInterface { id: dummyAlertItem
        opacity: visible ? 1.0 : 0.0
        Timer { id: timer; interval: 300; onTriggered: { parent.accepted(); } } // visible = false } }
        //Component.onDestruction: console.debug("dummy dead")
        Component.onCompleted: { //console.debug("dummy ready")
            var reg = root.popupRegistry
            reg.push(dummyAlertItem)
            root.popupRegistry = reg
            timer.start()
        }
    }}

    Component { id: combatPage
    Dialog {
        backNavigation: combat.done
        showNavigationIndicator: combat.done
        canAccept: false //combat.done
        property alias props: combat.props
        property alias you: combat.you
        backgroundColor: Theme.highlightDimmerFromColor("darkred", Theme.colorScheme)

        DialogHeader { id: header
            acceptText: ""
            cancelText: "Back to Page"
        }
        Combat {
            id: combat
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
    }

    Component { id: puzzlePage
    Dialog { id: dialog
        //backNavigation: puzzle.done
        //showNavigationIndicator: puzzle.done
        canAccept: false
        property alias answers: puzzle.answers
        property alias you: puzzle.you
        property string newpage: "not set"
        backgroundColor: Theme.highlightDimmerFromColor("darkblue", Theme.colorScheme)

        DialogHeader { id: header
            acceptText: ""
            cancelText: "Back to Page"
        }
        Puzzle {
            id: puzzle
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            onGoTo: { dialog.newpage = page; dialog.close() }
        }
    }
    }

    Rectangle {
        id: random
        anchors.fill: parent
        color: Theme.highlightDimmerFromColor("darkgreen", Theme.colorScheme)
        opacity: Theme.opacityOverlay
        visible: false

        property string randomNumber
        property bool numberRevealed: false

        onVisibleChanged: { 
            numberRevealed = false
            if (visible) {
                randomNumber = Util.getRandom()
                timer.start()
            }
        }
        Timer { id: timer; interval: 1000; onTriggered: random.numberRevealed = true }
        Column {
            spacing: Theme.paddingLarge
            width: parent.width
            anchors.centerIn: parent
            Label { id: islabel
                width: parent.width
                font.pixelSize: Theme.fontSizeLarge
                text: "Your random number is:"
                color: Theme.highlightColor
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                Behavior on y { PropertyAnimation { } }
            }
            Label { id: number
                width: parent.width
                font.pixelSize: Theme.fontSizeHuge
                text: random.randomNumber
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                opacity: random.numberRevealed ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation { duration: 3000; easing.type: Easing.InBounce } }
                color: opacity == 1 ? Theme.primaryColor : Theme.highlightColor
                Behavior on color { FadeAnimation { } }
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: random.numberRevealed
            onClicked: { random.visible = false; }
        }
    }

    function showMap() {
        imgViewer.source = Qt.resolvedUrl(book.cacheDir + "/" + "map.png")
        imgViewer.visible = true
    }
    Gallery.ImageViewer { id: imgViewer
        anchors.fill: parent
        anchors.centerIn: parent
        visible: false
        onClicked: visible = false
        opacity: visible ? 1.0 : 0
        Behavior on opacity { FadeAnimation{} }
    }

    Rectangle {
        id: downloadCover
        //onVisibleChanged: console.debug("showing")
        visible: false
        anchors.fill: parent
        opacity: book.progress == 100 ? 0 : Theme.opacityOverlay
        Behavior on opacity { FadeAnimation {} }
        color: Theme.highlightDimmerColor
        MouseArea {
            anchors.fill: parent
            enabled: visible
        }
        Item {
            id: downloadPage
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingSmall
            anchors.rightMargin: Theme.paddingSmall
            height: childrenRect.height
            Label {
                id: downloadLabel
                text: "Downloading..."
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
            }
            ProgressBar {
                id: progressBar
                minimumValue: 0
                maximumValue: 100
                value: book.progress
                anchors.top: downloadLabel.bottom
                anchors.topMargin: Theme.paddingSmall
                anchors.left: parent.left
                anchors.right: parent.right
                //indeterminate: true
            }
            SecondaryButton {
                id: cancelDownloadButton
                text: "Cancel"
                visible: false
                //color: theme.palette.normal.negative
                anchors.top: progressBar.bottom
                anchors.topMargin: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.pop()
            }
        }
    }

    Component {
        id: saveDialog
        Dialog {
            id: dialog
            DialogHeader { id: header; title: "Quick Save"; cancelText: "OK"; acceptText: "Got it" }
            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                anchors.leftMargin: Theme.paddingSmall
                anchors.rightMargin: Theme.paddingSmall
                anchors.topMargin: Theme.itemSizeLarge
                text: "This will save your current game state in case you want to load it later.  You can only load from the most recent time you saved."
                wrapMode: Text.Wrap
            }
        }
    }
}
