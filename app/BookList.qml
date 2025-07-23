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
        Grid {
            id: buttonFlow
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            columns: 2
            Repeater {
                model: root.model
                delegate: GridItem {
                    width: buttonFlow.width/2
                    contentHeight: cover.height
                    //contentHeight: cover.height + label.height + Theme.paddingMedium
                    BookCover { id: cover
                        width: parent.width
                        anchors.left: parent.left
                        book: model.book
                    }
                    /*
                    Label { id: label
                        anchors.horizontalCenter: cover.horizontalCenter
                        anchors.top: cover.bottom
                        anchors.topMargin: Theme.paddingMedium
                        text: "%1: %2".arg(index+1).arg(title)
                        wrapMode: Text.WordWrap
                    }
                    */
                    onClicked: root.startBook(book, title)
                }
                /*
                delegate: ValueButton {
                    label: "Book " + Number(index+1)
                    value: title
                    onClicked: root.startBook(book)
                }
                */
            }
        }
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
