import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Item {
    id: root

    property var you
    property string answers
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

    SilicaFlickable { id: flick
        anchors.fill: parent
        contentHeight: content.height

        Column { id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Theme.paddingSmall

            Label {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: Theme.itemSizeLarge
                anchors.bottomMargin: Theme.itemSizeLarge
                horizontalAlignment: Text.AlignHCenter
                text: "Enter number"
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
            }

            TextField {
                id: entry
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                horizontalAlignment: TextInput.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraLarge
                onTextChanged: {
                    d.wrong = false;
                }
            }

            ButtonLayout {
                Button { id: tryButton
                    text: "Try"
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

            Label {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                visible: d.wrong
                text: "Wrong"
                color: Theme.highlightFromColor(Theme.errorColor, Theme.colorScheme)
                font.pixelSize: Theme.fontSizeExtraLarge
                opacity: visible ? 1.0 : 0.0
                Behavior on opacity { FadeAnimation { duration: 2000 } }
            }
        }
    }
}
