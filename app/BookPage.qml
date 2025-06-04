import QtQuick 2.4
import QtFeedback 5.0
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
    //
    backgroundColor: Theme.highlightDimmerFromColor("#333300", Theme.colorScheme)

    Component {
        id: saveDialog
        Dialog {
            id: dialog
            DialogHeader { id: header; title: "Quick Save"; cancelText: "OK"; acceptText: "Got it" }
            Label {
                anchors.fill: parent
                anchors.topMargin: Screen.hasCutouts ? Screen.topCutout.height : 0
                text: "This will save your current game state in case you want to load it later.  You can only load from the most recent time you saved."
                wrapMode: Text.Wrap
            }
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
        //interactive: false
        //pressDelay: 0
        property bool wvHadFocus: pageView.focus
        property bool wvCanFocus: (!moving && !dragging && !dragging)
        onWvCanFocusChanged: {
            if (wvCanFocus) { wvHadFocus = pageView.focus; pageView.focus = false }
            else { if (wvHadFocus) pageView.focus = true }
        }
        PullDownMenu {
            visible: book.progress == 100
            MenuItem {
                id: backAction
                text: "Back"
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
            MenuItem {
                id: actionChart
                //icon.source: "note"
                text: "Action Chart"
                onClicked: pageStack.push(chartPage)
            }
            MenuItem {
                id: quickSave
                //icon.source: "save"
                text: "Quick Save"
                enabled: !book.inBackMatter && mainView.endurance > 0
                onClicked: {
                    if (quickSaveState.pageId == "") {
                        pageStack.push(saveDialog);
                    }
                    Remorse.popupAction(root, "Saved", function() { you.copyTo(quickSaveState); } )
                }
            }
            MenuItem {
                id: mapAction
                //icon.source: "location"
                text: "Map"
                onClicked: pageView.pageId = "map"
            }
        }
        /*
        PushUpMenu {
            visible: pageView.loaded
            MenuItem { text: "Increase Text size"; onClicked: WebEngineSettings.pixelRatio+=1 }
            MenuItem { text: "Decrease Text size"; onClicked: WebEngineSettings.pixelRatio-=1 }
        }
        */

    PageHeader { id: header
        title: book.pageTitle
        description: gameState.bookTitle
    }
    Item {
        id: endurancebar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        height: Theme.itemSizeLarge
        //color: Theme.highlightDimmerColor

        IconButton {
            id: minus
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Theme.paddingSmall
            //height: parent.height - Theme.paddingSmall
            //width: height
            icon.source: "image://theme/icon-splus-remove"
            enabled: mainView.endurance > 0
            onClicked: {
                haptics.play();
                adjustEndurance(-1)
            }
        }
        Label {
            id: youenduranceLabel
            text: mainView.endurance + "EP"
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.capitalization: Font.SmallCaps
            //font.family: "serif"
            //font.pixelSize: 
            width: parent.width - minus.width*2
        }
        IconButton {
            id: plus
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: Theme.paddingSmall
            icon.source: "image://theme/icon-splus-add"
            enabled: mainView.endurance < mainView.maxendurance
            onClicked: {
                haptics.play();
                adjustEndurance(1)
            }
        }
    }

    Book {
        id: book
        dir: Qt.resolvedUrl(".")
        filename: you.book ? you.book : "01fftd"
        pageId: pageView.pageId

        bgColor: "bisque"
        //textColor: "#212121"
        textColor: "#333300"
        linkColor:  Theme.highlightFromColor("bisque", Theme.DarkOnLight)

        onDirChanged: console.debug("Book dir:", dir, "Cache dir:", cacheDir)

        property bool inBackMatter: false

        onPageContentChanged: {
            if (pageId == "" && pageView.pageId != "")
                return; // on startup we get this fake-out...
            var content = pageContent;
            if (pageId != "title" && (pageType == "backmatter" || pageType == "deadend")) {
                inBackMatter = true;
            } else if (!inBackMatter) {
                you.pageId = pageId; // save place
            }
            //console.log("DEBUG page:", content);
            pageView.loadHtml(content, Qt.resolvedUrl(book.cacheDir) + "/");
        }
    }

    Rectangle { id: viewBorder
        border.color: "bisque"
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
        Connections {
            target: WebEngineSettings
            onPixelRatioChanged: uisettings.font = WebEngineSettings.pixelRatio
        }
        Component.onCompleted: {
            WebEngineSettings.pixelRatio = Math.ceil(uisettings.font)
            WebEngineSettings.autoLoadImages = true
            WebEngineSettings.popupEnabled = true
            WebEngineSettings.javascriptEnabled = true // <-- This apparently does not work, but the following does:
            WebEngineSettings.setPreference("javascript.enabled", true, WebEngineSettings.BoolPref)

            WebEngineSettings.setPreference("font.default.serif",      "serif", WebEngineSettings.StringPref)
            WebEngineSettings.setPreference("font.default.sans-serif", "serif", WebEngineSettings.StringPref)
            WebEngineSettings.setPreference("font.name-list.serif",    'Souvenir, "Sunset Serial Light", "Linux Biolinum", Georgia, "Times New Roman", serif, sans-serif', WebEngineSettings.StringPref)
            //WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)
            //WebEngineSettings.setPreference("security.disable_cors_checks", false, WebEngineSettings.BoolPref)
        }

        popupProvider: PopupProvider {
            //alertPopup: alertDialog
            alertPopup: { "type": "item", "component": alertDialog }
        }
    }

    Item {
        id: navigation
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: (previous.visible || next.visible || licenseButton.visible) ? Theme.itemSizeLarge : 0
        //color: Theme.highlightDimmerColor

        IconButton {
            id: previous
                anchors.left: parent.left
                anchors.bottom: parent.bottom
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
                anchors.bottom: parent.bottom
                anchors.margins: Theme.paddingSmall
                //height: parent.height - Theme.paddingSmall
                //width: height
                icon.source: "image://theme/icon-m-next"
                enabled: book.nextPageId != ""
                onClicked: pageView.pageId = book.nextPageId
            }

            Row {
                visible: !licenseButton.visible
                anchors.centerIn: parent
                spacing: Theme.paddingLarge
                IconButton {
                    icon.source: "image://theme/icon-splus-remove"
                    onClicked: WebEngineSettings.pixelRatio-=0.5
                }
                Icon {
                    height: textplus.height
                    width: textplus.width
                    source: "image://theme/icon-m-font-size"
                }
                IconButton { id: textplus
                    icon.source: "image://theme/icon-splus-add"
                    onClicked: WebEngineSettings.pixelRatio+=0.5
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
                    pageView.pageId = "";
                    book.downloadImages();
                }
            }
        }
    }

    Component { id: alertDialog; AlertPopupInterface {
        id: alertPopup
        anchors.fill: parent
        //preventDialogsPrefillValue: false
        //preventDialogsValue: false
        //preventDialogsVisible: false
        //Component.onCompleted: {
        onTextChanged: {
            console.debug("Executing alert action:", text)
            if (alertPopup.text == "random") {
                pageStack.push(random)
            } else if (alertPopup.text == "action") {
                haptics.play();
                pageStack.push(chartPage)
                alertPopup.accepted(); alertPopup.visible = false
            } else if (alertPopup.text.indexOf("combat,") == 0) {
                combat.props = alertPopup.text;
                combat.visible = true;
            } else if (alertPopup.text.indexOf("external,") == 0) {
                Qt.openUrlExternally(alertPopup.text.split(',')[1]);
                alertPopup.accepted(); alertPopup.visible = false
            } else if (alertPopup.text.indexOf("puzzle-page,") == 0) {
                puzzle.answers = alertPopup.text.split(',')[1];
                puzzle.visible = true;
            } else if (alertPopup.text.indexOf("book,") == 0) {
                haptics.play();
                you.book = alertPopup.text.split(',')[2];
                pageView.pageId = "";
                goToBookTab();
            } else {
                haptics.play();
                pageView.pageId = alertPopup.text;
                alertPopup.accepted(); alertPopup.visible = false
            }
        }

        Combat {
            id: combat
            anchors.fill: parent
            visible: false
            you: root.you
            onClose: { alertPopup.accepted(); alertPopup.visible = false }
        }

        Puzzle {
            id: puzzle
            anchors.fill: parent
            visible: false
            you: root.you
            onClose: { alertPopup.accepted(); alertPopup.visible = false }
            onGoTo: {
                pageView.pageId = page;
                alertPopup.accepted(); alertPopup.visible = false
            }
        }

        Rectangle {
            id: random
            anchors.fill: parent
            color: Theme.overlayBackgroundColor
            opacity: Theme.opacityOverlay
            visible: false
            property bool numberRevealed: false
            Timer { id: timer; running: visible; interval: 1000; onTriggered: random.numberRevealed = true }
            onVisibleChanged: numberRevealed = !visible
            Column {
                spacing: Theme.paddingLarge
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.leftMargin: Theme.horizontalPageMargin
                Label { id: islabel
                    width: parent.width
                    height: Theme.itemSizeLarge*3
                    font.pixelSize: Theme.fontSizeLarge
                    text: "Your random number is:"
                    color: Theme.highlightColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                }
                Label { id: number
                    width: parent.width
                    font.pixelSize: Theme.fontSizeHuge
                    text: Util.getRandom()
                    color: Theme.highlightColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    visible: random.numberRevealed
                    opacity: visible ? 1.0 : 0.0
                    Behavior on opacity { FadeAnimation { duration: 3000; easing.type: Easing.InBounce } }
                }
            }
            BackgroundItem {
                anchors.fill: parent
                onClicked: { alertPopup.accepted(); alertPopup.visible = false }
            }
        }
    }}


    Rectangle {
        id: downloadCover
        color: Theme.highlightDimmerColor
        anchors.fill: parent
        opacity: book.progress == 100 ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
        MouseArea {
            anchors.fill: parent
            enabled: parent.opacity == 1
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
}
