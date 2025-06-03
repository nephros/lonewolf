import QtQuick 2.4
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
            DialogHeader { id: header; title: "Quick Save"; acceptText: "Got it" }
            Label {
                anchors.fill: parent
                text: "This will save your current game state in case you want to load it later.  You can only load from the most recent time you saved."
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

    SilicaFlickable {
        anchors.fill: parent
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
                        PopupUtils.open(saveDialog);
                    }
                    you.copyTo(quickSaveState);
                }
            }
            MenuItem {
                id: mapAction
                //icon.source: "location"
                text: "Map"
                onClicked: pageView.pageId = "map"
            }
        }
        PushUpMenu {
            visible: pageView.loaded
            MenuItem { text: "Increase Text size"; onClicked: WebEngineSettings.pixelRatio+=1 }
            MenuItem { text: "Decrease Text size"; onClicked: WebEngineSettings.pixelRatio-=1 }
        }

    PageHeader { id: header
        title: book.pageTitle
        //description: mainView.endurance + "EP"
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
            onClicked: adjustEndurance(-1)
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
            onClicked: adjustEndurance(1);
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
        Component.onCompleted: {
            WebEngineSettings.pixelRatio = 2
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
            alertPopup: alertDialog
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
                visible: book.prevPageId != ""
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
                visible: book.nextPageId != ""
                onClicked: pageView.pageId = book.nextPageId
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
        anchors.fill: parent
        property var model

        Component.onCompleted: {
            if (model.message == "random") {
                random.visible = true;
            } else if (model.message == "action") {
                Haptics.play();
                actionChart.trigger();
                model.accept();
            } else if (model.message.indexOf("combat,") == 0) {
                combat.props = model.message;
                combat.visible = true;
            } else if (model.message.indexOf("external,") == 0) {
                Qt.openUrlExternally(model.message.split(',')[1]);
                model.accept();
            } else if (model.message.indexOf("puzzle-page,") == 0) {
                puzzle.answers = model.message.split(',')[1];
                puzzle.visible = true;
            } else if (model.message.indexOf("book,") == 0) {
                Haptics.play();
                you.book = model.message.split(',')[2];
                pageView.pageId = "";
                goToBookTab();
            } else {
                Haptics.play();
                pageView.pageId = model.message;
                model.accept();
            }
        }

        MouseArea {
            anchors.fill: parent
            // eat events that fall through
        }

        Combat {
            id: combat
            anchors.fill: parent
            visible: false
            you: root.you
            onClose: model.accept()
        }

        Puzzle {
            id: puzzle
            anchors.fill: parent
            visible: false
            you: root.you
            onClose: model.accept()
            onGoTo: {
                pageView.pageId = page;
                model.accept();
            }
        }

        Rectangle {
            id: random
            anchors.fill: parent
            color: "black"
            opacity: 0.95
            visible: false
            Column {
                spacing: units.gu(1)
                anchors.centerIn: parent
                Label {
                    text: "Your random number is:"
                    color: Theme.primaryColor
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.Wrap
                }
                Label {
                    text: Util.getRandom()
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: Theme.primaryColor
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: model.accept()
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
