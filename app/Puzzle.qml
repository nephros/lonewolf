import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Item {
    id: root

    property var you
    property string answers
    signal goTo(string page)

    property bool wrong: false
    property var guesses: []
    property int numGuesses: guesses.length

    onWrongChanged: {
        if (wrong) wrongItem.show()
    }

    onVisibleChanged: {
        if (visible) {
            entry.forceActiveFocus();
        }
    }

    Column { id: content
        width: parent.width
        anchors.centerIn: parent
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
            validator: RegExpValidator { regExp: /^[0-9]{1,}$/ }
            strictValidation: true
            onTextChanged: {
                wrong = false;
            }
            EnterKey.onClicked: focus = false
        }

        ButtonLayout { id: buttons
            Button { id: tryButton
                text: "Solve"
                enabled: content.enabled && entry.acceptableInput
                onClicked:{
                    var haystack = root.answers + " ";
                    var needle = "sect" + entry.text + " ";
                    if (haystack.indexOf(needle) >= 0) {
                        root.goTo("sect" + entry.text);
                    } else {
                        wrong = true;
                    }
                }
            }
        }
    }
    Item {
        anchors.top: content.bottom
        anchors.bottom: parent.bottom
        anchors.left: content.left
        anchors.right: content.right
        visible: numGuesses > 0
        Label {
            width: parent.width
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 7
            truncationMode: TruncationMode.Fade
            lineHeight: 1.2
            text: "<h3>Guessed (%1):</h3>%2".arg(numGuesses).arg(guesses.join("<br />"))
            textFormat: Text.StyledText
            color: Theme.highlightFromColor("yellow", Theme.colorScheme)
        }
    }
    Item { id: wrongItem
        anchors.top: parent.top
        anchors.bottom: content.top
        anchors.left: content.left
        anchors.right: content.right
        opacity: 0
        function show() { visible: true; content.enabled = false; fader.start() }
        SequentialAnimation { id: fader
            alwaysRunToEnd: true
            PropertyAnimation { id: fadein;  duration: 2000; target: wrongItem; property: "opacity"; from: 0; to: 1.0 }
            PropertyAnimation { id: fadeout; duration: 2000; target: wrongItem; property: "opacity"; from: 1.0; to: 0.0 }
            onStopped: {
              entry.forceActiveFocus();
              var g = root.guesses
              g.push(entry.text)
              root.guesses = g
              entry.text = ""
              content.enabled = true
            }
        }
        Label {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            text: "Wrong!"
            color: Theme.highlightFromColor(Theme.errorColor, Theme.colorScheme)
            font.pixelSize: Theme.fontSizeExtraLarge
        }
    }
}
