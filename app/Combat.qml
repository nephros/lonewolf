import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

Item {
    id: root

    property string props
    property var you
    property bool done: d.round == 1 || d.done

    QtObject {
        id: d
        property bool enduranceIsYours: false // true if we want to write endurance back to game state
        property int round: 1
        property string enemy
        property int combatskill
        property int endurance
        property int youcombatskill
        property int youendurance
        property bool done: youendurance <= 0 || endurance <= 0
    }

    Component.onCompleted: {
        // Make copies
        d.youendurance = mainView.endurance;
        d.youcombatskill = mainView.combatskill;

        var elements = props.split(',');
        for (var i = 0; i < elements.length; i++) {
            var keyvalue = elements[i].split('=');
            if (keyvalue[0] == 'enemy') {
                d.enemy = keyvalue[1];
            } else if (keyvalue[0] == 'combatskill') {
                d.combatskill = keyvalue[1];
            } else if (keyvalue[0] == 'endurance') {
                d.endurance = keyvalue[1];
                d.enduranceIsYours = true;
            } else if (keyvalue[0] == 'resistance') {
                enduranceTitle.text = "RESISTANCE";
                d.endurance = keyvalue[1];
                d.enduranceIsYours = true;
            } else if (keyvalue[0] == 'target') {
                enduranceTitle.text = "TARGET";
                d.endurance = keyvalue[1];
                youenduranceTitle.text = "TARGET";
                d.youendurance = keyvalue[1];
            } else if (keyvalue[0] == 'duel') {
                d.combatskill = d.youcombatskill - keyvalue[1];
                d.endurance = d.youendurance;
            }
        }
    }

    Binding {
        target: you
        property: inneworder ? "neworder_endurance" : "endurance"
        value: d.youendurance
        when: d.enduranceIsYours
    }

    ButtonLayout { id: buttons
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.itemSizeMedium
        z: flick.z + 1
        SecondaryButton {
            id: fleeButton
            text: "Evade"
            //color: Theme.highlightFromColor(Theme.errorColor, Theme.colorScheme)
            enabled: !d.done
            onClicked: {
                var rand = Util.getRandom();
                var delta = d.youcombatskill - d.combatskill;

                var damageToYou = Util.getDamageToYou(delta, rand);
                if (damageToYou < 0) {
                    d.youendurance = 0;
                } else {
                    if (youDoubleDamage.checked)
                        damageToYou = damageToYou * 2;
                    d.youendurance = Math.max(d.youendurance - damageToYou, 0);
                }

                d.done = true;
            }
        }
        Button {
            text: "Fight"
            //color: Theme.highlightFromColor(Theme.errorColor, Theme.colorScheme)
            enabled: !d.done
            onClicked: {
                var rand = Util.getRandom();
                var delta = d.youcombatskill - d.combatskill;

                var damageToYou = Util.getDamageToYou(delta, rand);
                if (damageToYou < 0) {
                    d.youendurance = 0;
                } else {
                    if (youDoubleDamage.checked)
                        damageToYou = damageToYou * 2
                    d.youendurance = Math.max(d.youendurance - damageToYou, 0);
                }

                var damageToEnemy = Util.getDamageToEnemy(delta, rand);
                if (damageToEnemy < 0) {
                    d.endurance = 0;
                } else {
                    if (doubleDamage.checked)
                        damageToEnemy = damageToEnemy * 2;
                    d.endurance = Math.max(d.endurance - damageToEnemy, 0);
                }

                if (!d.done)
                    d.round++;
            }
        }
    }

    SilicaFlickable { id: flick
        anchors.fill: parent
        contentHeight: content.height

        Column { id: content
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Theme.paddingLarge

            Label { id: label
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: Theme.itemSizeLarge
                anchors.bottomMargin: Theme.itemSizeLarge
                horizontalAlignment: Text.AlignHCenter
                text: "Round " + d.round
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
            }

            Item { id: columns
                anchors.left: parent.left
                anchors.right: parent.right
                height: Math.max(youcol.height, themcol.height)
                Column { id: youcol
                    anchors.right: parent.horizontalCenter
                    anchors.left: parent.left
                    spacing: Theme.paddingMedium
                    Label {
                        text: "You"
                        //color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeLarge
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: youenduranceLabel
                        text: d.youendurance > 0 || youenduranceTitle.text != "Endurance"  ? d.youendurance : "DEAD"
                        color: d.youendurance > 0 ? Theme.primaryColor : Theme.errorColor
                        font.pixelSize: Theme.fontSizeExtraLarge
                        font.capitalization: Font.SmallCaps
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            anchors.left: youenduranceLabel.right
                            anchors.leftMargin: Theme.paddingSmall
                            anchors.verticalCenter: youenduranceLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "+"
                            onClicked: d.youendurance += 1
                            //color: "transparent"
                        }
                        Button {
                            anchors.right: youenduranceLabel.left
                            anchors.rightMargin: Theme.paddingSmall
                            anchors.verticalCenter: youenduranceLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "-"
                            onClicked: d.youendurance -= 1
                            //color: "transparent"
                        }
                    }
                    Label {
                        id: youenduranceTitle
                        text: "Endurance"
                        font.capitalization: Font.SmallCaps
                        color: Theme.highlightColor
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: youcombatskillLabel
                        text: d.youcombatskill
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeExtraLarge
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            anchors.left: youcombatskillLabel.right
                            anchors.leftMargin: Theme.paddingSmall
                            anchors.verticalCenter: youcombatskillLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "+"
                            enabled: !d.done
                            onClicked: d.youcombatskill += 1
                        }
                        Button {
                            anchors.right: youcombatskillLabel.left
                            anchors.rightMargin: Theme.paddingSmall
                            anchors.verticalCenter: youcombatskillLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "-"
                            enabled: !d.done
                            onClicked: d.youcombatskill -= 1
                        }
                    }
                    Label {
                        text: "Combat Skill"
                        color: Theme.highlightColor
                        font.capitalization: Font.SmallCaps
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    TextSwitch { id: youDoubleDamage
                        text: "weak (×2 damage)"
                        description: "(only enable if instructed)"
                        leftMargin: 0
                        rightMargin: 0
                    }
                }
                Column { id: themcol
                    anchors.left: parent.horizontalCenter
                    anchors.right: parent.right
                    spacing: Theme.paddingMedium
                    Label {
                        text: d.enemy
                        //color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeLarge
                        minimumPixelSize: Theme.fontSizeTiny
                        fontSizeMode: Text.HorizontalFit
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: enduranceLabel
                        text: d.endurance > 0 || enduranceTitle.text != "Endurance" ? d.endurance : "DEAD"
                        color: d.endurance > 0 ? Theme.primaryColor : Theme.errorColor
                        font.pixelSize: Theme.fontSizeExtraLarge
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        Button {
                            anchors.left: enduranceLabel.right
                            anchors.leftMargin: Theme.paddingSmall
                            anchors.verticalCenter: enduranceLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "+"
                            onClicked: d.endurance += 1
                        }
                        Button {
                            anchors.right: enduranceLabel.left
                            anchors.rightMargin: Theme.paddingSmall
                            anchors.verticalCenter: enduranceLabel.verticalCenter
                            width: Theme.buttonWidthTiny
                            text: "-"
                            onClicked: d.endurance -= 1
                        }
                    }
                    Label {
                        id: enduranceTitle
                        text: "Endurance"
                        color: Theme.highlightColor
                        font.capitalization: Font.SmallCaps
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: combatskillLabel
                        text: d.combatskill
                        color: Theme.primaryColor
                        font.pixelSize: Theme.fontSizeExtraLarge
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        text: "Combat Skill"
                        color: Theme.highlightColor
                        font.capitalization: Font.SmallCaps
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    TextSwitch { id: doubleDamage
                        text: "weak (×2 damage)"
                        description: "(only enable if instructed)"
                        leftMargin: 0
                        rightMargin: 0

                    }
                }
            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
