import QtQuick 2.4
import Sailfish.Silica 1.0

Column { id: root
    property var model
    property string title
    property string description
    property var product: null
    property bool buying
    signal startBook(string book)

    spacing: Theme.paddingSmall
    width: parent.width

    /*
    Item {
        width: parent.width
        height: title.height //Math.max(title.height, buyButton.height)
        Label {
            id: title
            text: root.title
            font.pixelSize: Theme.fontSizeLarge
            font.bold: true
            color: Theme.highlightColor
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right //buyButton.left
            verticalAlignment: Text.AlignBottom
        }
        Button {
            id: buyButton
            visible: root.product && !root.product.bought
            enabled: !root.buying
            text: "$2.99"
            color: theme.palette.normal.positive
            anchors.right: parent.right
            anchors.top: parent.top
        }
    }
    */
    Label {
        id: title
        text: root.title
        font.pixelSize: Theme.fontSizeLarge
        font.bold: true
        color: Theme.highlightColor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right //buyButton.left
        verticalAlignment: Text.AlignBottom
    }
    Label {
        text: root.description
        width: parent.width
        wrapMode: Text.Wrap
        color: Theme.secondaryHighlightColor
    }
    Grid {
        id: buttonFlow
        columns: 7
        horizontalItemAlignment: Grid.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - marginWidth * 2
        spacing: Theme.paddingLarge
        property real buttonWidth: Theme.buttonWidthTiny
        property real marginWidth: (parent.width - buttonWidth) % (buttonWidth + spacing) / 2
        Repeater {
            model: root.model
            delegate: Button {
                //icon.source: (root.product && !root.product.bought) ? "locked" : ""
                //text: (root.product && !root.product.bought) ? "" : index + 1
                text: index + 1
                onClicked: root.startBook(book)
                width: buttonFlow.buttonWidth
                height: width
                //color: "#203432"
                //enabled: !root.product || root.product.bought
            }
        }
    }
}

