import QtQuick 2.4
import QtFeedback 5.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
import Sailfish.WebView.Popups 1.0
import Lonewolf 1.0

WebViewPage {
    id: root

    property var you
    property bool canDoBackAction: false
    //readonly property product: bookProduct()

    Behavior on backgroundColor { ColorAnimation {} }
    backgroundColor: mainView.nightModeEnabled
         ? "black"
         : Theme.highlightDimmerFromColor(mainView.bookColor, Theme.colorScheme)

    canNavigateForward: imgViewer.visible ? false : forwardNavigation

    onStatusChanged: {
        if ((root.status == PageStatus.Active) && (pageStack.nextPage() == null)) {
            var cp = pageStack.pushAttached(chartPage)
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
        makeImgViewer()
    }

    ThemeEffect { id: haptics; effect: ThemeEffect.PressWeak }
    ThemeEffect { id: success; effect: ThemeEffect.PressStrong }
    SilicaFlickable { id: flickable
        opacity: imgViewer.visible ? Theme.opacityFaint : 1.0
        Behavior on opacity { FadeAnimator { } }
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
            quickSelect: true
            MenuItem {
                id: quickSave
                //icon.source: "save"
                text: "Quick Save"
                enabled: book.inGame && (mainView.endurance > 0)
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
        Behavior on opacity { FadeAnimator { } }
        BackgroundItem { id: mapButton
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
                opacity: parent.enabled ? 1.0 : Theme.opacityFaint
                Behavior on opacity { FadeAnimator { } }
            }
            enabled: book.inGame && (mainView.endurance > 0)
            onClicked: root.showMap()
        }
        /*
        BackgroundItem {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: mapButton.right
            anchors.leftMargin: Theme.paddingLarge
            width: Theme.iconSizeMedium
            height: Theme.iconSizeMedium
            Icon { id: imgIcon
                property color iconColor: parent.enabled ? Theme.highlightColor : Theme.secondaryColor
                Behavior on iconColor { ColorAnimation { easing.type: Easing.InBounce } }
                anchors.centerIn: parent
                anchors.fill: parent
                source: "image://theme/icon-m-image?" + iconColor
                cache: true
            }
            Label {
                anchors.centerIn: imgIcon
                text: book.images.length > 0 ? book.images.length : ""
                color: Theme.darkPrimaryColor
            }
            enabled: book.images.length > 0
            onClicked: root.showIllustration()
            opacity: enabled ? 1.0 : Theme.opacityFaint
            Behavior on opacity { FadeAnimator { } }
        }
        */
    }

    StatusBar { id: endurancebar }

    Book {
        id: book
        dir: Qt.resolvedUrl(".")
        filename: you.book ? you.book : "01fftd"
        pageId: pageView.pageId

        //property var images: []

        Behavior on bgColor { ColorAnimation {} }
        bgColor:   mainView.nightModeEnabled ? "black" : "bisque"
        textColor: mainView.nightModeEnabled ? "#8E8E93" : "#333300"
        linkColor: Theme.highlightFromColor("bisque", (mainView.nightModeEnabled ? Theme.LightOnDark : Theme.DarkOnLight ))

        //onDirChanged: console.debug("Book dir:", dir)
        //onCacheDirChanged: console.debug("Cache dir:", cacheDir)

        property bool inBackMatter: false
        property bool inFrontMatter: false
        property bool inGame: !inBackMatter && !inFrontMatter

        onPageContentChanged: {
            //console.debug("Loading:", pageId, pageType)
            var content = pageContent;
            // FIXME: What to do if dead?
            if (pageId != "title" && (pageType == "backmatter" || pageType == "deadend")) {
                inBackMatter = true;
            } else if (pageType == "frontmatter" || pageType == "frontmatter-separate") {
                inFrontMatter = true;
            } else if (pageId == "map") {
                showMap()
            } else if (!inBackMatter) {
                you.pageId = pageId; // save place
            }

            // base and CSP should be first.
            var newcontent = content.replace(
                /<head>/,
                '<head>
                <meta http-equiv="Content-Security-Policy" content="img-src \'self\' https://www.projectaon.org/" />
                '
            )
            var newstyle
            if (uisettings.styleHtml) {
                newstyle=[
                    '<style>* { font-family: lone-wolf, Souvenir, "ITC Souvenir", AG_Souvenir, Alegreya, "Linux Biolinum", Baskerville, Garamond, serif;}</style>',
                    '<style> p { text-align: justify; }</style>',
                    (mainView.nightModeEnabled
                        ? '<style> .actionlink { border-bottom: 1px dashed #414141; }</style>'
                        : '<style> .actionlink { border-bottom: 1px dashed #212121; }</style>'
                    ),
                    (mainView.nightModeEnabled
                        ? '<style> .pagelink { border-bottom: 1px solid #414141; }</style>'
                        : '<style> .pagelink { border-bottom: 1px solid #212121; }</style>'
                    ),
                    '<style> .attribute { font-variant-caps: small-caps; }</style>',
                    '<style> .footnote { font-style: italic; }</style>',
                    '<style> .dedication { font-style: italic; font-weight: bold; text-align: center; margin-left: auto; margin-right: auto; }</style>',
                    '<style> .sound { font-style: italic; }</style>',
                    '<style> dt { font-weight: bold; }</style>',
                    '<style> figure { margin-left: auto; margin-right: auto; }</style>',
                    //'<style> img { border: 1px solid #000000; width: 90%; display: block; margin-left: auto; margin-right: auto; }</style>',
                    (mainView.nightModeEnabled
                        ? '<style> img { filter: invert(100%) sepia(40%) brightness(80%); width: 90%; display: block; margin-left: auto; margin-right: auto; }</style>'
                        : '<style> img { filter: sepia(120%); width: 90%; display: block; margin-left: auto; margin-right: auto; }</style>'
                    ),
                    '<style> figcaption { font-style: italic; text-align: center;}</style>',
                    '<style> quote:before { content: \'“\'; }</style>',
                    '<style> quote:after { content: \'”\'; }</style>',
                    //'<style> :-moz-suppressed { border: 2px dashed #ff0000; }</style>',
                    //'<style> :-moz-broken { border: 2px dashed #00ff00; }</style>',
                    //'<style> :-moz-user-disabled { border: 2px dashed #000000; }</style>',
                    ].join('\n')
            } else {
                newstyle=[
                    (mainView.nightModeEnabled
                        ? '<style> img { filter: invert(100%) brightness(80%); width: 90%; display: block; margin-left: auto; margin-right: auto; }</style>'
                        : '<style> img { filter: sepia(120%); width: 90%; display: block; margin-left: auto; margin-right: auto; }</style>'
                    ),
                    (mainView.nightModeEnabled
                        ? '<style> .actionlink { border-bottom: 1px dashed #414141; }</style>'
                        : '<style> .actionlink { border-bottom: 1px dashed #212121; }</style>'
                    ),
                    (mainView.nightModeEnabled
                        ? '<style> .pagelink { border-bottom: 1px solid #414141; }</style>'
                        : '<style> .pagelink { border-bottom: 1px solid #212121; }</style>'
                    ),
                    ].join('\n')
            }
            newcontent = newcontent.replace('</head>', newstyle + '\n' + '</head>')

            /*
            // as we can't get webview to load images, lets extract them:
            var imgurls = []
            var match
            const imgre = /<img[^>]+src="?([^"\s]+)"?\s*\/>/g;
            while ( match = imgre.exec( content ) ) { imgurls.push( "file://" + book.cacheDir + "/" + match[1] ); }
            book.images = imgurls
            if (images.length) console.debug("images:", book.images.join("\n"))
            */

            newcontent = newcontent.replace(/onerror=[^ ]+/g, '')
            // url from backend. Since we can't load local resources, go online.
            newcontent = newcontent.replace(/src="/g, 'onclick="alert(\'image,\' + this.src +\'\')" src="https://www.projectaon.org/en/xhtml/lw/' + filename +  '/');
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

        onTextSelectionActiveChanged: { clearSelection() }
        canShowSelectionMarkers: false
        chromeGestureEnabled: false
        // Hack/FIXME: how do I disable text selection properly? (CSS works but leads to JS error in textSelectionHandler.js of mozembed)
        /*
        textSelectionController: Item {
                function selectionRangeUpdated(data) { return true }
                property Item contentItem
        }
        */

        onRecvAsyncMessage: function(message, data) {
            //console.log("Async Message: ", message, JSON.stringify(data));
            if (message == "embed:alert") {
                handleUserClick(data.text)
            }
        }
        onLoadedChanged: { // text-to-speech
            if (loaded) {
                if ((mainView.haveTts) && (uisettings.autoTts)) {
                    if (mainView.titleRead != mainView.bookTitle) {
                        pageView.readText(mainView.bookTitle)
                        mainView.titleRead = mainView.bookTitle
                    } else if (book.inGame) { pageView.readText() }
                }
            }
        }
        function handleUserClick(text) {
            if (text == "random") {
                //random.visible = true
                random.show()
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
            } else if (text.indexOf("image,") == 0) {
                const parts = text.split(',')[1].split("/")
                showIllustration(Qt.resolvedUrl(book.cacheDir + "/" + parts[parts.length-1]))
            } else if (text.indexOf("external,") == 0) {
                Qt.openUrlExternally(text.split(',')[1]);
            } else if (text.indexOf("puzzle-page,") == 0) {
                puzzlePanel.answers = text.split(',')[1]
                puzzlePanel.you = root.you
                puzzlePanel.show()
            } else if (text.indexOf("book,") == 0) {
                console.debug("Switching Book", you.book)
                // "book,lw,09foo"
                haptics.play();
                you.copyTo(lastBook);
                you.book = text.split(',')[2];
                pageView.pageId = "";
                popBookTab();
            } else {
                haptics.play();
                pageView.pageId = text;
            }
            //console.debug("Executed alert action:", text)
        }

        function readText(prefix) {
            runJavaScript("
                var pageText = document.body.textContent;
                if (pageText) { return pageText } else { return 'empty'};
            ",
            function(result) {
                   //console.log("Document text is", result)
                   if (result != "empty") mainView.ttsPlay(prefix + ".\n \n" + result)
            }
            );
        }

        Connections {
            target: WebEngineSettings
            onPixelRatioChanged: uisettings.fontF = WebEngineSettings.pixelRatio
        }
        Component.onCompleted: {
            WebEngineSettings.pixelRatio = uisettings.fontF
            WebEngineSettings.autoLoadImages = true
            //WebEngineSettings.setPreference("permissions.default.image", 1, WebEngineSettings.IntPref)
            WebEngineSettings.javascriptEnabled = true // <-- This apparently does not work, but the following does:
            WebEngineSettings.setPreference("javascript.enabled", true, WebEngineSettings.BoolPref)

            //WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.csp.enable", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.disable_cors_checks", true, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.mixed_content.block_active_content", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.mixed_content.block_display_content", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.mixed_content.upgrade_display_content.image", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("privacy.file_unique_origin", false, WebEngineSettings.BoolPref)
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
                visible: !licenseButton.visible
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
                visible: !licenseButton.visible
            }

            Row { id: plusminus
                visible: !licenseButton.visible
                anchors.centerIn: parent
                IconButton {
                    icon.source: "image://theme/icon-splus-remove"
                    onClicked: WebEngineSettings.pixelRatio-=0.2
                }
                IconButton {
                    icon.source: "image://theme/icon-m-font-size?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                    onClicked: WebEngineSettings.pixelRatio = Theme.dp(1)
                }
                IconButton {
                    icon.source: "image://theme/icon-splus-add"
                    onClicked: WebEngineSettings.pixelRatio+=0.2
                }
            }

            IconButton { id: readbtn
                icon.source: mainView.ttsSpeaking
                    ? "image://theme/icon-m-speaker-on?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                    : "image://theme/icon-m-speaker?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                highlighted: down || mainView.ttsSpeaking
                onClicked: mainView.ttsSpeaking ?  mainView.ttsStop() : pageView.readText()
                visible: mainView.haveTts && !licenseButton.visible
                anchors.left: previous.right
                anchors.right: plusminus.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingLarge
                property bool hintShown: false
            }
            TapInteractionHint{ id: ttshint; running: false; loops: 3; taps: 1; anchors.centerIn: readbtn }
            InteractionHintLabel{ visible: ttshint.running; text: "Text-to-Speech"
                //anchors.left: parent.left
                //anchors.right: parent.horizontalCenter
                anchors.bottom: ttshint.top
                //backgroundColor: "transparent"
                textColor: mainView.nightModeEnabled ? Theme.highlightColor : Theme.darkPrimaryColor
            }

            IconButton { id: nightmode
                icon.source: "image://theme/icon-m-light-contrast?" + (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
                onClicked: mainView.nightModeEnabled = !mainView.nightModeEnabled
                visible: !licenseButton.visible
                anchors.right: next.left
                anchors.left: plusminus.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingLarge
                property bool hintShown: false
            }
            TapInteractionHint{ id: hint; running: false; loops: 3; taps: 1; anchors.centerIn: nightmode }
            InteractionHintLabel{ visible: hint.running; text: "Night Mode toggle"
                //anchors.right: parent.right
                //anchors.left: parent.horizontalCenter
                anchors.bottom: hint.top
                //backgroundColor: "transparent"
                textColor: mainView.nightModeEnabled ? Theme.highlightColor : Theme.darkPrimaryColor
            }
            Timer {
                running: uisettings.showHints
                    && parent.visible
                    && (!nightmode.hintShown || !readbtn.hintShown)
                    && !licenseButton.visible
                interval: 2000
                repeat: true
                onTriggered: {
                    if (!nightmode.hintShown) { hint.start(); nightmode.hintShown = true }
                    else if (haveTts && !hint.running && !readbtn.hintShown) { ttshint.start(); readbtn.hintShown = true }
                    if (nightmode.hintShown && readbtn.hintShown) uisettings.showHints = false
                }
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
                    // We have a game state, but the book was not downloaded.
                    // --> restore the page
                    if ((you.book == book.filename) && (you.pageId != "")) {
                        pageView.pageId = you.pageId
                    } else {
                        pageView.pageId = "";
                    }
                    book.downloadImages();
                }
            }
        }
    }

    /* Our dummy popup thing never gets deleted. See https://github.com/sailfishos/sailfish-components-webview/issues/179
     * So collect them and destroy from time to time:
    */
    QtObject { id: popupRegistry
        readonly property int max: 50
        property var purgatory: []
        //property list<QtObject> purgatory
        function purge() {
            //console.debug("popups:", popupCount)
            if (purgatory.length > max) {
                //console.debug("Cleaning up popups:", purgatory.length)
                for (var i = max; i < purgatory.length-1; ++i) {
                    purgatory[i].destroy()
                }
                purgatory.length = max
                //console.debug("Cleaned up popups, remaining:", purgatory.length)
            }
        }
    }
    /*
    property int popupCount: popupRegistry.length
    property var popupRegistry: []
    onPopupCountChanged: {
        //console.debug("popups:", popupCount)
        if (popupRegistry.length > 50) {
            //console.debug("Cleaning up popups")
            var tmp = popupRegistry
            for (var i = 0; i < popupRegistry.length-1; ++i) {
                tmp[i].destroy()
            }
            popupRegistry = tmp
        }
    }
    */

    Component { id: dummyAlertPopup; AlertPopupInterface { id: dummyAlertItem
        opacity: visible ? 1.0 : 0.0
        Timer { id: timer; interval: 300; onTriggered: { parent.accepted(); } } // visible = false } }
        //Component.onDestruction: console.debug("dummy dead")
        Component.onCompleted: { //console.debug("dummy ready")
            popupRegistry.purgatory.push(dummyAlertItem)
            popupRegistry.purge()
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
        Behavior on backgroundColor { ColorAnimation {} }
        backgroundColor: mainView.nightModeEnabled
           ? "black"
           : Theme.highlightDimmerFromColor("darkred", Theme.colorScheme)
        Image {
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            source: "./combat_trans.png"
            fillMode: Image.PreserveAspectFit
        }
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

    DockedPanel { id: puzzlePanel
        width:  parent.width
        height: parent.height/3
        dock: Dock.Bottom
        modal: true
        property alias answers: puzzle.answers
        property alias you: puzzle.you
        Separator {
            width: parent.width
            anchors.verticalCenter: parent.top
            horizontalAlignment: Qt.AlignHCenter
        }
        Rectangle {
            id: puzzleRect
            anchors.fill: parent
            Behavior on color { ColorAnimation {} }
            color: mainView.nightModeEnabled
                ? "black"
                : Theme.highlightDimmerFromColor(mainView.bookColor, Theme.colorScheme)
            opacity: Theme.opacityOverlay
        }
        Puzzle { id: puzzle
            anchors.fill: parent
            onGoTo: {
              succes.play()
              pageView.pageId = solution
              puzzlePanel.hide()
          }
        }
    }

    DockedPanel { id: random
        width:  parent.width
        height: parent.height/2
        dock: Dock.Bottom
        modal: true
        property string randomNumber
        property bool numberRevealed: false
        onOpenChanged: { 
            numberRevealed = false
            if (open) {
                randomNumber = Util.getRandom()
                timer.start()
            }
        }
        Timer { id: timer; interval: 1000; onTriggered: random.numberRevealed = true }
        Image {
            anchors.fill: parent; anchors.centerIn: parent; 
            source: "./lonewolf-bighead.png"
            fillMode: Image.PreserveAspectFit
        }
        Rectangle {
            id: randomRect
            anchors.fill: parent
            color: Theme.highlightDimmerFromColor(mainView.bookColor, Theme.colorScheme)
            opacity: Theme.opacityOverlay
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
                    Behavior on opacity { FadeAnimator { duration: 3000; easing.type: Easing.InBounce } }
                    color: opacity == 1 ? Theme.primaryColor : Theme.highlightColor
                    Behavior on opacity { FadeAnimator { } }
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: random.open && random.numberRevealed
                //onClicked: { random.visible = false; }
                onClicked: { random.hide() }
            }
        }
    }

    function showIllustration(source) {
        imgViewer.source = source
        imgViewer.visible = true
        imgViewer.map = false
    }

    function showMap() {
        imgViewer.source = Qt.resolvedUrl(book.cacheDir + "/" + "map.png")
        imgViewer.visible = true
        imgViewer.map = true
    }

    // slight Sepia and somw desat if night mode
    Colorize { id: mapcol
        z: imgViewer.z+1
        visible: (imgViewer.opacity > 0) && imgViewer.map
        source: imgViewer
        anchors.fill: imgViewer
        opacity: mainView.nightModeEnabled ? 0.5 : 0.25
        saturation: 0.5
        hue: 0.07
        lightness: -0.4
    }

    // Sepia for day mode
    Colorize { id: daycol
        z: imgViewer.z+1
        visible: !mainView.nightModeEnabled && (imgViewer.opacity > 0) && !imgViewer.map
        source: imgViewer
        anchors.fill: imgViewer
        saturation: 0.5
        hue: 0.14
        lightness: 0
    }

    // needed by inverter
    Image { id: allWhite
        visible: false
        source: 'white-square.png'
        anchors.fill: imgViewer
    }

    // invert in night mode
    Blend { id: inverter
        visible: false
        source: imgViewer
        foregroundSource: allWhite
        mode: 'negation'
        anchors.fill: imgViewer
    }
    // Sepia and de-brightness for night mode
    Colorize { id: nightcol
        z: imgViewer.z+1
        visible: mainView.nightModeEnabled && (imgViewer.opacity > 0) && !imgViewer.map
        source: inverter
        anchors.fill: imgViewer
        saturation: 0.2
        hue: 0.07
        lightness: 0
    }

    // avoid detection of dependency to Sailfish.Gallery:
    // sorry, harbour people! ;)
    property QtObject imgViewer
    function makeImgViewer() {
      var qml = "
          import QtQuick 2.4
          import Sailfish.Silica 1.0
         " + [ "import", "Sailfish.Gallery", "1.0" ].join(" ") + "\n"
         + " ImageViewer { id: imgViewer
             property bool map: false
             anchors.fill: parent
             anchors.centerIn: parent
             visible: false
             active: visible
             onClicked: visible = false
             opacity: visible ? 1.0 : 0
             //Behavior on opacity { FadeAnimator{} }
         }"
         imgViewer = Qt.createQmlObject(qml, root)
    }

    Rectangle {
        id: downloadCover
        //onVisibleChanged: console.debug("showing")
        visible: false
        anchors.fill: parent
        opacity: book.progress == 100 ? 0 : Theme.opacityOverlay
        onOpacityChanged: if (opacity == 0) visible = false
        Behavior on opacity { FadeAnimator { } }
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
                //onClicked: pageStack.pop()
                onClicked: { downloadCover.visible = false; popBookTab(); }
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

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
