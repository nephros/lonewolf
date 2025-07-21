import QtQuick 2.4
import Sailfish.Silica 1.0

Item {
    id: root

    property var model
    property string title
    property string description
    property var product: null
    property bool buying
    signal startBook(string book)

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
        Column {
            id: buttonFlow
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            Repeater {
                model: root.model
                delegate: ValueButton {
                    label: "Book " + Number(index+1)
                    value: title
                    onClicked: root.startBook(book)
                }
            }
        }
    }
}

