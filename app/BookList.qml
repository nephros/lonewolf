import QtQuick 2.4
import Sailfish.Silica 1.0

Item {
    id: root

    property var model
    property string title
    property string description
    property var product: null
    property bool buying
    signal startBook(string book, string title)

    height: column.height
    anchors.bottomMargin: Theme.paddingMedium

    Column {
        id: column
        spacing: Theme.paddingSmall
        width: parent.width

        Label {
            id: title
            width: parent.width
            text: root.title
            font.pixelSize: Theme.fontSizeLarge
            font.bold: true
            color: Theme.highlightColor
        }
        Label {
            text: root.description
            width: parent.width
            wrapMode: Text.Wrap
            color: Theme.secondaryHighlightColor
        }
        SlideshowView { id: slides
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width // - Theme.horizontalPageMargin
            height: itemWidth/600*800
            //clip: true
            itemWidth: Math.floor(width / 2.5)
            Component.onCompleted: positionViewAtIndex(0, PathView.Beginning)
            model: root.model
            delegate: GridItem {
                anchors.leftMargin: Theme.paddingSmall
                anchors.rightMargin: Theme.paddingSmall
                width: slides.itemWidth
                contentHeight: cover.height
                BookCover { id: cover
                    width: parent.width
                    book: model.book
                }
                Label {
                    //anchors.fill: cover
                    width: cover.width
                    anchors.centerIn: cover
                    visible: (cover.status == Image.Error)
                    text: title
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                onClicked: root.startBook(book, title)
            }
        }
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
