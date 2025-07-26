import QtQuick 2.4
import Sailfish.Silica 1.0
import Lonewolf 1.0

// This is not a class I am proud of.  So much weird duplication of code.

Page {
    id: root
    clip: true

    property var you

    backgroundColor: mainView.nightModeEnabled
        ? "black"
        //: "#7f7f4c"
        : Theme.highlightDimmerFromColor(mainView.bookColor, Theme.colorScheme)


    states: [
        State { name: "kai"; when: mainView.inkai
            PropertyChanges { target: d; kai: true }

            PropertyChanges { target: disciplines; columns: 2; rows: 5 }
            PropertyChanges { target: disciplines_repeater; model: kaidisciplinesModel }
            PropertyChanges { target: disciplines_header; text: "Kai Disciplines" }

            PropertyChanges { target: kairank; visible: true }

            PropertyChanges { target: weaponmastery_header; visible: false }
            PropertyChanges { target: weaponmastery; visible: false }

            PropertyChanges { target: quiver; visible: false } // the others have it
        },
        State { name: "magnakai"; when: mainView.inmagnakai
            PropertyChanges { target: d; magnakai: true }

            PropertyChanges { target: disciplines; columns: 2; rows: 5 }
            PropertyChanges { target: disciplines_repeater; model: magnakaidisciplinesModel }
            PropertyChanges { target: disciplines_header; text:  "Magnakai Disciplines" }

            PropertyChanges { target: magnakairank; visible: true }

            PropertyChanges { target: weaponmastery_header; text: "Weaponmastery" }
            PropertyChanges { target: weaponmastery_repeater; model: weaponmasteryModel }

        },
        State { name: "grandmaster"; when: mainView.ingrandmaster
            PropertyChanges { target: d; grandmaster: true }
            PropertyChanges { target: disciplines; columns: 2; rows: 6 }
            PropertyChanges { target: disciplines_repeater; model: grandmasterdisciplinesModel }
            PropertyChanges { target: disciplines_header; text: "Kai Grand Master Disciplines" }

            PropertyChanges { target: weaponmastery_header; text: "Grand Weaponmastery" }
            PropertyChanges { target: weaponmastery_repeater; model: grandweaponmasteryModel }

        },
        State { name: "neworder"; when: mainView.inneworder
            PropertyChanges { target: d; neworder: true }

            PropertyChanges { target: disciplines; columns: 2; rows: 8 }
            PropertyChanges { target: disciplines_repeater; model: neworderdisciplinesModel }
            PropertyChanges { target: disciplines_header; text: "New Order Kai Grand Master Disciplines" }

            PropertyChanges { target: weaponmastery_header; text: "Grand Weaponmastery" }
            PropertyChanges { target: weaponmastery_repeater; model: neworderweaponmasteryModel }


            PropertyChanges { target: backpack; visible: false }
            PropertyChanges { target: neworder_backpack; visible: true }

            //PropertyChanges { target: weapons; visible: false }
            PropertyChanges { target: kaiweapon; visible: true }
            PropertyChanges { target: specials; visible: false }
            PropertyChanges { target: neworder_specials; visible: true }
        }
    ]

    QtObject {
        id: d
        // deprecated aliases, didn't want to bother searching and replacing
        property bool kai: false
        property bool magnakai: false
        property bool grandmaster: false
        property bool neworder: false
    }

    QtObject { id: c
        // conveniance properties, display only:
        property bool _magnakai_circle_fire: you.magnakai_huntmastery && you.magnakai_weaponmastery
        property bool _magnakai_circle_light: you.magnakai_curing && you.magnakai_animalcontrol
        property bool _magnakai_circle_solaris: you.magnakai_huntmastery && you.magnakai_pathsmanship && you.magnakai_invisibility
        property bool _magnakai_circle_spirit: you.magnakai_psisurge && you.magnakai_psiscreen && you.magnakai_nexus && you.magnakai_divination
    }

    Image {
        source: d.magnakai ? "./ac-02.png" : "./ac-01.png"
        fillMode: Image.PreserveAspectFit
        //anchors.bottom: parent.bottom
        anchors.bottom: flicker.bottom
        anchors.right: flicker.right
        anchors.margins: Theme.paddingLarge
        width: flicker.width*4/5
        height: flicker.height/3
        opacity: 0.8
        cache: true; smooth: false
    }

    ListModel { id: kaidisciplinesModel
        ListElement {
            text: "Camouflage"
            prop: "kai_camouflage"
            note: "Blend in with your surroundings"
        }
        ListElement {
            text: "Hunting"
            prop: "kai_hunting"
            note: "Skip a meal in certain areas"
        }
        ListElement {
            text: "Sixth Sense"
            prop: "kai_sixthsense"
            note: "Warns about imminent danger"
        }
        ListElement {
            text: "Tracking"
            prop: "kai_tracking"
            note: "Find the right path"
        }
        ListElement {
            text: "Healing"
            prop: "kai_healing"
            note: "+1 EP for each section without combat"
        }
        ListElement {
            text: "Weaponskill"
            prop: "kai_weaponskill"
            note: "+2 CS for with chosen weapon"
        }
        ListElement {
            text: "Mindshield"
            prop: "kai_mindshield"
            note: "Immune to Mindblast attack"
        }
        ListElement {
            text: "Mindblast"
            prop: "kai_mindblast"
            note: "+2 CS against most enemies"
        }
        ListElement {
            text: "Animal Kinship"
            prop: "kai_animalkinship"
            note: "Communiate with some animals"
        }
        ListElement {
            text: "Mind Over Matter"
            prop: "kai_mindovermatter"
            note: "Move small objects with your mind"
        }
    }

    ListModel { id: magnakaidisciplinesModel
        ListElement {
            text: "Weaponmastery"
            prop: "magnakai_weaponmastery"
            note: "+3 CS for with chosen weapon"
        }
        ListElement {
            text: "Animal Control"
            prop: "magnakai_animalcontrol"
            note: ""
        }
        ListElement {
            text: "Curing"
            prop: "magnakai_curing"
            note: "+1 EP for each section without combat"
        }
        ListElement {
            text: "Invisibility"
            prop: "magnakai_invisibility"
            note: ""
        }
        ListElement {
            text: "Huntmastery"
            prop: "magnakai_huntmastery"
            note: "Skip a meal requirement"
        }
        ListElement {
            text: "Pathsmanship"
            prop: "magnakai_pathsmanship"
            note: ""
        }
        ListElement {
            text: "Psi-surge"
            prop: "magnakai_psisurge"
            note: "+4CS/-2 EP, or +2CS per round of combat"
        }
        ListElement {
            text: "Psi-screen"
            prop: "magnakai_psiscreen"
            note: ""
        }
        ListElement {
            text: "Nexus"
            prop: "magnakai_nexus"
            note: ""
        }
        ListElement {
            text: "Divination"
            prop: "magnakai_divination"
            note: ""
        }
     }

     ListModel { id: grandmasterdisciplinesModel
         ListElement {
             text: "Grand Weaponmastery"
             prop: "grandmaster_grandweaponmastery"
         }
         ListElement {
             text: "Animal Mastery"
             prop: "grandmaster_animalmastery"
         }
         ListElement {
             text: "Deliverance"
             prop: "grandmaster_deliverance"
         }
         ListElement {
             text: "Assimilance"
             prop: "grandmaster_assimilance"
         }
         ListElement {
             text: "Grand Huntmastery"
             prop: "grandmaster_grandhuntmastery"
         }
         ListElement {
             text: "Grand Pathsmanship"
             prop: "grandmaster_grandpathsmanship"
         }
         ListElement {
             text: "Kai-surge"
             prop: "grandmaster_kaisurge"
         }
         ListElement {
             text: "Kai-screen"
             prop: "grandmaster_kaiscreen"
         }
         ListElement {
             text: "Grand Nexus"
             prop: "grandmaster_grandnexus"
         }
         ListElement {
             text: "Telegnosis"
             prop: "grandmaster_telegnosis"
         }
         ListElement {
             text: "Magi-magic"
             prop: "grandmaster_magimagic"
         }
         ListElement {
             text: "Kai-alchemy"
             prop: "grandmaster_kaialchemy"
         }
     }

     ListModel { id: neworderdisciplinesModel
         ListElement {
             text: "Grand Weaponmastery"
             prop: "neworder_grandweaponmastery"
         }
         ListElement {
             text: "Animal Mastery"
             prop: "neworder_animalmastery"
         }
         ListElement {
             text: "Deliverance"
             prop: "neworder_deliverance"
         }
         ListElement {
             text: "Assimilance"
             prop: "neworder_assimilance"
         }
         ListElement {
             text: "Grand Huntmastery"
             prop: "neworder_grandhuntmastery"
         }
         ListElement {
             text: "Grand Pathsmanship"
             prop: "neworder_grandpathsmanship"
         }
         ListElement {
             text: "Kai-surge"
             prop: "neworder_kaisurge"
         }
         ListElement {
             text: "Kai-screen"
             prop: "neworder_kaiscreen"
         }
         ListElement {
             text: "Grand Nexus"
             prop: "neworder_grandnexus"
         }
         ListElement {
             text: "Telegnosis"
             prop: "neworder_telegnosis"
         }
         ListElement {
             text: "Magi-magic"
             prop: "neworder_magimagic"
         }
         ListElement {
             text: "Kai-alchemy"
             prop: "neworder_kaialchemy"
         }
         ListElement {
             text: "Astrology"
             prop: "neworder_astrology"
         }
         ListElement {
             text: "Herbmastery"
             prop: "neworder_herbmastery"
         }
         ListElement {
             text: "Elementalism"
             prop: "neworder_elementalism"
         }
         ListElement {
             text: "Bardsmanship"
             prop: "neworder_bardsmanship"
         }
     }

     ListModel { id: weaponmasteryModel
         ListElement {
             text: "Dagger"
             prop: "weaponmastery_dagger"
         }
         ListElement {
             text: "Mace"
             prop: "weaponmastery_mace"
         }
         ListElement {
             text: "Warhammer"
             prop: "weaponmastery_warhammer"
         }
         ListElement {
             text: "Axe"
             prop: "weaponmastery_axe"
         }
         ListElement {
             text: "Quarterstaff"
             prop: "weaponmastery_quarterstaff"
         }
         ListElement {
             text: "Spear"
             prop: "weaponmastery_spear"
         }
         ListElement {
             text: "Short Sword"
             prop: "weaponmastery_shortsword"
         }
         ListElement {
             text: "Bow"
             prop: "weaponmastery_bow"
         }
         ListElement {
             text: "Sword"
             prop: "weaponmastery_sword"
         }
         ListElement {
             text: "Broadsword"
             prop: "weaponmastery_broadsword"
         }
     }

     ListModel { id: grandweaponmasteryModel
         ListElement {
             text: "Dagger"
             prop: "grandweaponmastery_dagger"
         }
         ListElement {
             text: "Mace"
             prop: "grandweaponmastery_mace"
         }
         ListElement {
             text: "Warhammer"
             prop: "grandweaponmastery_warhammer"
         }
         ListElement {
             text: "Axe"
             prop: "grandweaponmastery_axe"
         }
         ListElement {
             text: "Quarterstaff"
             prop: "grandweaponmastery_quarterstaff"
         }
         ListElement {
             text: "Spear"
             prop: "grandweaponmastery_spear"
         }
         ListElement {
             text: "Short Sword"
             prop: "grandweaponmastery_shortsword"
         }
         ListElement {
             text: "Bow"
             prop: "grandweaponmastery_bow"
         }
         ListElement {
             text: "Sword"
             prop: "grandweaponmastery_sword"
         }
         ListElement {
             text: "Broadsword"
             prop: "grandweaponmastery_broadsword"
         }
     }

     ListModel { id: neworderweaponmasteryModel
         ListElement {
             text: "Dagger"
             prop: "neworder_grandweaponmastery_dagger"
         }
         ListElement {
             text: "Mace"
             prop: "neworder_grandweaponmastery_mace"
         }
         ListElement {
             text: "Warhammer"
             prop: "neworder_grandweaponmastery_warhammer"
         }
         ListElement {
             text: "Axe"
             prop: "neworder_grandweaponmastery_axe"
         }
         ListElement {
             text: "Quarterstaff"
             prop: "neworder_grandweaponmastery_quarterstaff"
         }
         ListElement {
             text: "Spear"
             prop: "neworder_grandweaponmastery_spear"
         }
         ListElement {
             text: "Short Sword"
             prop: "neworder_grandweaponmastery_shortsword"
         }
         ListElement {
             text: "Bow"
             prop: "neworder_grandweaponmastery_bow"
         }
         ListElement {
             text: "Sword"
             prop: "neworder_grandweaponmastery_sword"
         }
         ListElement {
             text: "Broadsword"
             prop: "neworder_grandweaponmastery_broadsword"
         }
     }

    SilicaFlickable {
        id: flicker
        anchors.fill: parent
        contentHeight: col.height + col.anchors.margins * 2
        contentWidth: width

        Column {
            id: col
            spacing: Theme.paddingSmall
            x: anchors.margins
            y: anchors.margins
            anchors.margins: Theme.paddingSmall
            width: flicker.contentWidth - anchors.margins * 2

            PageHeader { id: header; title: "Action Chart" }

            Grid { id: basicgrid
                columns: 3
                anchors.margins: Theme.paddingSmall
                verticalItemAlignment: Grid.AlignVCenter
                columnSpacing: Theme.paddingSmall
                rowSpacing: Theme.paddingSmall
                Label {
                    text: "Max Endurance"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                }
                ChartItem {
                    you: root.you
                    text: d.neworder ? you.neworder_maxendurance : you.maxendurance
                    prop: d.neworder ?  "neworder_maxendurance" : "maxendurance"
                    width: combatSkillBox.width
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Item {height: 1; width: 1} // spacer/placeholder for Grid


                Label { text: "Endurance"; color: Theme.highlightColor; font.capitalization: Font.SmallCaps }
                ChartItem {
                    you: root.you
                    text: d.neworder ? you.neworder_endurance : you.endurance
                    prop: d.neworder ? "endurance" : "neworder_endurance"
                    width: combatSkillBox.width
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_endurance -=1 : you.endurance -=1
                        enabled:   d.neworder ? (you.neworder_endurance > 0) : (you.endurance > 0)
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_endurance +=1 : you.endurance +=1
                        enabled: d.neworder ?  (you.neworder_endurance < you.neworder_maxendurance) : (you.endurance < you.maxendurance)
                    }
                }

                Label { text: "Combat Skill"; color: Theme.highlightColor; font.capitalization: Font.SmallCaps }
                ChartItem { id: combatSkillBox
                    you: root.you
                    text: d.neworder ? you.neworder_combatskill : you.combatskill
                    prop: d.neworder ? "neworder_combatskill"  : "combatskill"
                    width: Theme.buttonWidthSmall
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_combatskill -=1 : you.combatskill -=1
                        enabled: d.neworder ? you.neworder_combatskill > 0 : you.combatskill > 0
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_combatskill +=1 : you.combatskill +=1
                    }
                }

                Label {
                    text: "Belt Pouch"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                }
                ChartItem {
                    you: root.you
                    text: d.neworder ? you.neworder_gold : you.gold
                    prop: d.neworder ?  "neworder_gold" : "gold"
                    description: "Max 50"
                    inputMethodHints: Qt.ImhDigitsOnly
                    width: Theme.buttonWidthSmall
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_gold -=1 : you.gold -=1
                        enabled: d.neworder ? (you.neworder_gold > 0) : (you.gold > 0)
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_gold +=1 : you.gold +=1
                        enabled: d.neworder ? (you.neworder_gold < 50) : (you.gold < 50)
                    }
                }
                Label { id: quiverlabel
                    text: "Quiver"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                    visible: quiver.visible
                }
                ChartItem { id: quiver
                    width: Theme.buttonWidthSmall
                    you: root.you
                    text: d.neworder ? you.neworder_quiver : you.quiver
                    prop: d.neworder ? "neworder_quiver" : "quiver"
                    description: "Max 6"
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Row {
                    visible: quiver.visible
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_quiver -=1 : you.quiver -=1
                        enabled: d.neworder ? (you.neworder_quiver > 0) : (you.quiver >0)
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_quiver +=1 : you.quiver +=1
                    }
                }

                Label {
                    text: "Meals"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                }
                ChartItem {
                    width: Theme.buttonWidthSmall
                    you: root.you
                    text: d.neworder ? you.neworder_meals : you.meals
                    prop: "meals"
                    description: "Each fills a backpack slot"
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_meals -=1 : you.meals -=1
                        enabled: d.neworder ? (you.neworder_meals > 0) : (you.meals > 0)
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_meals +=1 : you.meals +=1
                    }
                }
            }

            SectionHeader {
                text: "Weapons"
                font.capitalization: Font.SmallCaps
                visible: weapons.visible
            }
            Grid { id: weapons
                columns: 2
                rows: 1
                flow: Grid.TopToBottom
                property real itemWidth: (col.width - spacing) / 2

                ChartItem {
                    width: weapons.itemWidth
                    you: root.you
                    text: d.neworder ? you.neworder_weapon1 : you.weapon1
                    prop: d.neworder ? "neworder_weapon1" : "weapon1"
                }
                ChartItem {
                    width: weapons.itemWidth
                    you: root.you
                    text: d.neworder ? you.neworder_weapon2 : you.weapon2
                    prop: d.neworder ? "neworder_weapon2" : "weapon2"
                }
            }
            SectionHeader {
                visible: kaiweapon.visible
                text: "Kai Weapon"
                font.capitalization: Font.SmallCaps
            }
            ChartItem { id: kaiweapon
                width: col.width
                you: root.you
                text: you.neworder_kaiweapon
                prop: "neworder_kaiweapon"
                visible: false
            }

            SectionHeader {
                text: "Backpack Items\n(%1 meals: %2 free)".arg(meals).arg(slots)
                font.capitalization: Font.SmallCaps
                property int meals: d.neworder ? you.neworder_meals : you.meals
                property int slots: ((d.neworder || d.grandmaster) ? 10 : 8) - meals
            }
            Grid {
                id: backpack
                columns: 2
                //rows: 5
                flow: Grid.LeftToRight
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                Repeater { model: d.grandmaster ? 10 : 8
                    delegate: ChartItem {
                        width: backpack.itemWidth
                        you: root.you
                        text: you[prop]
                        prop: "backpack" + Number(index+1)
                        label: (((d.grandmaster ? 10 : 8) - you.meals ) <= index)
                               ? "Meal" : ""
                        acceptableInput: (label != "Meal") || (text.length == 0)
                    }
                }
            }
            Grid {
                id: neworder_backpack
                columns: 2
                rows: 5
                flow: Grid.LeftToRight
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                visible: false
                Repeater{ model: 10
                    delegate: ChartItem {
                        width: neworder_backpack.itemWidth
                        you: root.you
                        text: you[prop]
                        prop: "neworder_backpack" + Number(index+1)
                        label: ((10 - you.neworder_meals ) <= index)
                               ? "Meal" : ""
                        acceptableInput: (label != "Meal") || (text.length == 0)
                    }
                }
            }

            SectionHeader {
                text: "Special Items"
                font.capitalization: Font.SmallCaps
                visible: specials.visible || neworder_specials.visible
            }
            Grid { id: specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: col.width
                Repeater { model: 12
                    delegate: ChartItem {
                        width: specials.itemWidth
                        you: root.you
                        text: you[prop]
                        prop: "special" + Number(index+1)
                    }
                }
            }
            Grid { id: neworder_specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                visible: false
                property real itemWidth: col.width
                Repeater { model: 12
                    delegate: ChartItem {
                        width: neworder_specials.itemWidth
                        you: root.you
                        text: you[prop]
                        prop: "neworder_special" + Number(index+1)
                    }
                }
            }

            SectionHeader { id: disciplines_header
                font.capitalization: Font.SmallCaps
            }

            DetailItem { id: kairank
                visible: false
                width: parent.width/2
                label: "Rank"
                value: ranknames[rank]
                property int rank: countRanks()
                readonly property var ranknames: [
                    "",
                    "Novice",
                    "Intuite",
                    "Doan",
                    "Acolyte",
                    "Initiate", //--You begin the Lone Wolf adventures with this level of Kai training
                    "Aspirant",
                    "Guardian",
                    "Warmarn or Journeyman",
                    "Savant",
                    "Master",
                ]
                function countRanks() {
                    const keys = [
                      "kai_camouflage", "kai_hunting", "kai_sixthsense",
                      "kai_tracking", "kai_healing", "kai_weaponskill", "kai_mindshield",
                      "kai_mindblast", "kai_animalkinship", "kai_mindovermatter",
                    ]
                    const r = keys.reduce(function(acc, val, idx) {
                          if (you[val]) { acc +=1 }
                          return acc
                    }, 0)
                    return r
                }
            }
            Row { id: magnakairank
                visible: false
                width: parent.width
                DetailItem {
                    width: parent.width/2
                    label: "Rank"
                    value: ranknames[rank]
                    property int rank: countRanks()
                    readonly property var ranknames: [
                        "",
                        "Kai Master",
                        "Kai Master Senior",
                        "Kai Master Superior", // --You begin the Lone Wolf Magnakai adventures with this level of training.
                        "Primate", // 4
                        "Tutelary",
                        "Principalin", // 6
                        "Mentora",
                        "Scion-kai",
                        "Archmaster", // 9
                        "Kai Grand Master",
                    ]
                    function countRanks() {
                        const keys = [
                            "magnakai_weaponmastery", "magnakai_animalcontrol",
                            "magnakai_curing", "magnakai_invisibility", "magnakai_huntmastery",
                            "magnakai_pathsmanship", "magnakai_psisurge", "magnakai_psiscreen",
                            "magnakai_nexus", "magnakai_divination",
                        ]

                        const r = keys.reduce(function(acc, val, idx) {
                              if (you[val]) { acc +=1 }
                              return acc
                        }, 0)
                        return r
                    }
                }
                DetailItem {
                    width: parent.width/2
                    label: "Lore Circles"
                    value: ""
                        + (c._magnakai_circle_fire    ? "Circle of Fire\n" : ""  )
                        + (c._magnakai_circle_light   ? "Circle of Light\n" : ""  )
                        + (c._magnakai_circle_solaris ? "Circle of Solaris\n"  : "" )
                        + (c._magnakai_circle_spirit  ? "Circle of Spirit"  : "" )
                }
            }

            Grid { id: disciplines
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                Repeater { id: disciplines_repeater
                    delegate: ChartCheck {
                        you: root.you
                        text: model.text
                        checked: you[model.prop]
                        prop: model.prop
                        note: model.note ? model.note : ""
                        width: disciplines.itemWidth
                    }
                }
            }
            SectionHeader { id: weaponmastery_header
                font.capitalization: Font.SmallCaps
            }
            Grid { id: weaponmastery
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                Repeater { id: weaponmastery_repeater
                    delegate: ChartCheck {
                        you: root.you
                        text: model.text
                        checked: you[model.prop]
                        prop: model.prop
                        width: weaponmastery.itemWidth
                    }
                }
            }

            SectionHeader {
                text: "Notes"
                font.capitalization: Font.SmallCaps
                font.pixelSize: Theme.fontSizeLarge
            }
            TextArea {
                id: notes
                width: parent.width
                text: d.neworder ? you.neworder_notes : you.notes
                Binding {
                    target: you
                    property: d.neworder ? "neworder_notes" : "notes"
                    value: notes.text
                }
            }
        }
    }
}

