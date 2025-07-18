/*
 * This file is part of Lone Wolf
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Sailfish.Silica 1.0

Rectangle {
    id: endurancebar
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: header.bottom
    height: Math.max(varrow.height, endurancerow.height) + Theme.paddingSmall
    color:  mainView.nightModeEnabled ? "black" : Theme.highlightDimmerFromColor(book.bgColor, Theme.colorScheme)
    Behavior on color { ColorAnimation {} }


    property bool hintShown: false
    TapInteractionHint{ id: hint; running: false; loops: 3; taps: 1; anchors.centerIn: varrow }
    InteractionHintLabel{ visible: hint.running; text: "Switch Gold, Meals, ..."
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.bottom: hint.bottom
        //backgroundColor: "transparent"
        textColor: mainView.nightModeEnabled ? Theme.highlightColor : Theme.darkPrimaryColor
        invert: true
    }
    Timer {
        running: uisettings.showHints
            && parent.visible
            && !hintShown
            && mainView.gold > 0
        interval: 10000
        onTriggered: {
            if (!hintShown) { hint.start(); hintShown = true }
        }
    }
    Row { id: varrow
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        property string currentProperty: "gold"
        property alias label: varlabel.text
        state:  "gold"
        states: [
            State { name: "gold"
                PropertyChanges { target: varrow
                    currentProperty: "gold"
                    label: "%1 Crowns".arg(mainView.gold)
                }
                PropertyChanges { target: varplus;  enabled: mainView.gold < 50 }
                PropertyChanges { target: varminus; enabled: mainView.gold > 0 }
            },
            State { name: "meals"
                PropertyChanges { target: varrow
                    currentProperty: "meals"
                    label: "%1 Meals".arg(mainView.meals)
                }
                PropertyChanges { target: varplus;  enabled: mainView.meals < 8 }
                PropertyChanges { target: varminus; enabled: mainView.meals > 0 }
            },
            State { name: "quiver"
                PropertyChanges { target: varrow
                    currentProperty: "quiver"
                    label: "%1 Arrows".arg(mainView.quiver)
                }
                PropertyChanges { target: varplus;  enabled: true } // max usually 6, sometimes 12 mainView.quiver < 6 }
                PropertyChanges { target: varminus; enabled: mainView.quiver > 0 }
            }
        ]
        IconButton { id: varplus
            anchors.margins: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-splus-add"
            onClicked: {
                haptics.play();
                adjustProperty(varrow.currentProperty, 1)
            }
        }
        transitions: Transition { SequentialAnimation {
            PropertyAnimation { from: 1.0; to: 0.0; target: varrow; properties: "opacity" }
            PropertyAnimation { from: 0.0; to: 1.0; target: varrow; properties: "opacity" }
        }}
        Label { id: varlabel
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Theme.itemSizeLarge, implicitWidth)
            font.capitalization: Font.SmallCaps
            color: (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
            Behavior on color { ColorAnimation {} }
            truncationMode: TruncationMode.Fade
            BackgroundItem {
                anchors.fill: parent
                onClicked: {
                    switch (varrow.state) {
                        case "gold":  varrow.state = "meals"; break;
                        case "meals": varrow.state = mainView.inneworder ? "quiver" : "gold"; break
                        case "quiver": varrow.state = "gold"
                        default: varrow.state = "gold"
                    }
                }
            }
        }
        IconButton { id: varminus
            anchors.margins: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-splus-remove"
            onClicked: {
                haptics.play();
                adjustProperty(varrow.currentProperty, -1)
            }
        }
    }

    Row { id: endurancerow
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingLarge
        IconButton {
            anchors.margins: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-splus-add"
            enabled: mainView.endurance < mainView.maxendurance
            onClicked: {
                haptics.play();
                adjustEndurance(1)
            }
        }
        Label {
            text: "%1 Endurance".arg(mainView.endurance)
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.capitalization: Font.SmallCaps
            color: (!mainView.nightModeEnabled ? Theme.primaryColor : Theme.secondaryColor)
            truncationMode: TruncationMode.Fade
        }
        IconButton {
            anchors.margins: Theme.paddingSmall
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-splus-remove"
            enabled: mainView.endurance > 0
            onClicked: {
                haptics.play();
                adjustEndurance(-1)
            }
        }
    }
}


// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4

