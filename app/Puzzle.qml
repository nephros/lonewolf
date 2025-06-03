import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Rectangle {
    id: root
    color: "black"
    opacity: 0.95

    property var you
    property string answers
    signal close()
    signal goTo(string page)

    QtObject {
        id: d
        property bool wrong
    }

    onVisibleChanged: {
        if (visible) {
            entry.forceActiveFocus();
        }
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: Theme.dp(4)
        anchors.left: parent.left
        anchors.right: parent.right
        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            text: "Enter number"
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeExtraLarge
        }

        Item { width: Theme.dp(1); height: Theme.dp(2); }

        Row {
            spacing: Theme.dp(1)
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: entry
                width: Theme.dp(10)
                height: FontUtils.sizeToPixels("x-large") + Theme.dp(2)
                inputMethodHints: Qt.ImhDigitsOnly
                //hasClearButton: false
                horizontalAlignment: TextInput.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                onTextChanged: {
                    d.wrong = false;
                }
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                text: "Try"
                //color: theme.palette.normal.positive
                onClicked:{
                    var haystack = root.answers + " ";
                    var needle = "sect" + entry.text + " ";
                    if (haystack.indexOf(needle) >= 0) {
                        root.goTo("sect" + entry.text);
                    } else {
                        d.wrong = true;
                        entry.forceActiveFocus();
                    }
                }
            }
        }

        Item { width: Theme.dp(1); height: Theme.dp(2); }

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            visible: d.wrong
            text: "Wrong"
            //color: theme.palette.normal.negative
            font.pixelSize: Theme.fontSizeExtraLarge
        }
    }

    Button {
        id: cancelButton
        text: "Back to Page"
        color: UbuntuColors.lightGrey
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.topMargin: Theme.dp(1)
        anchors.bottomMargin: Theme.dp(1)
        onClicked: root.close()
    }
}
