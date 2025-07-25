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

    QtObject {
        id: d
        // deprecated aliases, didn't want to bother searching and replacing
        readonly property int kai: mainView.inkai
        readonly property int magnakai: mainView.inmagnakai
        readonly property int grandmaster: mainView.ingrandmaster
        readonly property int neworder: mainView.inneworder
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
     ListModel { id: weaponproficiencyModel
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

            PageHeader { id: header
                title: "Action Chart"
            }

            Grid {
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
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.maxendurance
                    you: root.you
                    prop: "maxendurance"
                    width: combatSkillBox.width
                    visible: !d.neworder
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_maxendurance
                    you: root.you
                    prop: "neworder_maxendurance"
                    width: combatSkillBox.width
                    visible: d.neworder
                }
                Item {height: 1; width: 1} // spacer/placeholder for Grid


                Label {
                    text: "Endurance"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.endurance
                    you: root.you
                    prop: "endurance"
                    width: combatSkillBox.width
                    visible: !d.neworder
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_endurance
                    you: root.you
                    prop: "neworder_endurance"
                    width: combatSkillBox.width
                    visible: d.neworder
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_endurance -=1 : you.endurance -=1
                        enabled: d.neworder ? (you.neworder_endurance > 0) : (you.endurance > 0)
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        enabled: (you.endurance < you.maxendurance)
                        onClicked: d.neworder ? you.neworder_endurance +=1 : you.endurance +=1
                    }
                }

                Label {
                    text: "Combat Skill"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                }
                ChartItem {
                    id: combatSkillBox
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.combatskill
                    you: root.you
                    prop: "combatskill"
                    width: Theme.buttonWidthSmall
                    visible: !d.neworder
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_combatskill
                    you: root.you
                    prop: "neworder_combatskill"
                    width: Theme.buttonWidthSmall
                    visible: d.neworder
                }
                Row {
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-remove"
                        onClicked: d.neworder ? you.neworder_combatskill -=1 : you.combatskill -=1
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
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.gold
                    you: root.you
                    prop: "gold"
                    width: Theme.buttonWidthSmall
                    visible: !d.neworder
                    description: "Max 50"
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_gold
                    you: root.you
                    prop: "neworder_gold"
                    width: Theme.buttonWidthSmall
                    visible: d.neworder
                    description: "Max 50"
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
                Label {
                    text: "Quiver"
                    color: Theme.highlightColor
                    font.capitalization: Font.SmallCaps
                    visible: d.magnakai || d.grandmaster || d.neworder
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.quiver
                    you: root.you
                    prop: "quiver"
                    width: Theme.buttonWidthSmall
                    visible: d.magnakai || d.grandmaster
                    description: "Max 6"
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_quiver
                    you: root.you
                    prop: "neworder_quiver"
                    width: Theme.buttonWidthSmall
                    visible: d.neworder
                    description: "Max 6"
                }
                Row {
                    visible: d.magnakai || d.grandmaster || d.neworder
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
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.meals
                    you: root.you
                    prop: "meals"
                    width: Theme.buttonWidthSmall
                    visible: !d.neworder
                    description: "Each fills a backpack slot"
                }
                ChartItem {
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: you.neworder_meals
                    you: root.you
                    prop: "neworder_meals"
                    width: Theme.buttonWidthSmall
                    visible: d.neworder
                    description: "Each fills a backpack slot"
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
            }
            Grid {
                id: weapons
                columns: 2
                rows: 1
                flow: Grid.TopToBottom
                property real itemWidth: (col.width - spacing) / 2
                visible: !d.neworder

                ChartItem {
                    text: you.weapon1
                    you: root.you
                    prop: "weapon1"
                    width: weapons.itemWidth
                }
                ChartItem {
                    text: you.weapon2
                    you: root.you
                    prop: "weapon2"
                    width: weapons.itemWidth
                }
            }
            Grid {
                id: neworder_weapons
                columns: 2
                rows: 1
                flow: Grid.TopToBottom
                visible: d.neworder

                ChartItem {
                    text: you.neworder_weapon1
                    you: root.you
                    prop: "neworder_weapon1"
                    width: weapons.itemWidth
                }
                ChartItem {
                    text: you.neworder_weapon2
                    you: root.you
                    prop: "neworder_weapon2"
                    width: weapons.itemWidth
                }
            }

            SectionHeader {
                text: "Backpack Items (%1 meals: %2 free)".arg(meals).arg(slots)
                font.capitalization: Font.SmallCaps
                property int meals: d.neworder ? you.neworder_meals : you.meals
                property int slots: (d.grandmaster ? 10 : 8) - meals
            }
            Grid {
                id: backpack
                columns: 2
                //rows: 5
                flow: Grid.LeftToRight
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                visible: !d.neworder
                Repeater { model: d.grandmaster ? 10 : 8
                    delegate: ChartItem {
                        text: you[prop]
                        you: root.you
                        prop: "backpack" + Number(index+1)
                        width: backpack.itemWidth
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
                visible: d.neworder
                Repeater{ model: 10
                    delegate: ChartItem {
                        text: you[prop]
                        you: root.you
                        prop: "neworder_backpack" + Number(index+1)
                        width: neworder_backpack.itemWidth
                        label: ((10 - you.neworder_meals ) <= index)
                               ? "Meal" : ""
                        acceptableInput: (label != "Meal") || (text.length == 0)
                    }
                }
            }

            Label {
                text: "Kai Weapon"
                color: Theme.highlightColor
                visible: d.neworder
            }
            ChartItem {
                text: you.neworder_kaiweapon
                you: root.you
                prop: "neworder_kaiweapon"
                width: col.width
                visible: d.neworder
            }

            SectionHeader {
                text: "Special Items"
                font.capitalization: Font.SmallCaps
            }
            Grid {
                id: specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: col.width
                visible: !d.neworder
                Repeater { model: 12
                    delegate: ChartItem {
                        text: you[prop]
                        you: root.you
                        prop: "special" + Number(index+1)
                        width: specials.itemWidth
                    }
                }
            }
            Grid {
                id: neworder_specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.neworder
                Repeater { model: 12
                    delegate: ChartItem {
                        text: you[prop]
                        you: root.you
                        prop: "neworder_special" + Number(index+1)
                        width: neworder_specials.itemWidth
                    }
                }
            }

            SectionHeader {
                text: "Kai Disciplines"
                font.capitalization: Font.SmallCaps
                visible: d.kai
            }

            DetailItem {
                visible: d.kai
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

            SectionHeader {
                text: "Magnakai Disciplines"
                font.capitalization: Font.SmallCaps
                visible: d.magnakai
            }

            Row {
                width: parent.width
                visible: d.magnakai
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


            Grid {
                id: disciplines
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                visible: d.kai || d.magnakai
                Repeater {
                    model: d.kai ? kaidisciplinesModel : (d.magnakai ? magnakaidisciplinesModel : undefined )
                    delegate: ChartCheck {
                        you: root.you
                        text: model.text
                        checked: you[model.prop]
                        prop: model.prop
                        note: model.note
                        width: disciplines.itemWidth
                    }
                }
            }
            SectionHeader {
                text: "Weaponmastery Proficiencies"
                font.capitalization: Font.SmallCaps
                color: Theme.highlightColor
                visible: d.magnakai
            }
            Grid { id: weaponprofgrid
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: false
                property real itemWidth: (col.width - spacing) / 2
                Repeater { id: wprofrepeater
                    delegate: ChartCheck {
                        you: root.you
                        text: model.text
                        checked: you[model.prop]
                        prop: model.prop
                        width: weaponprofgrid.itemWidth
                    }
                }
            }

            SectionHeader {
                text: "Grand Master Disciplines"
                font.capitalization: Font.SmallCaps
                visible: d.grandmaster
            }
            Grid {
                columns: 2
                rows: 6
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.grandmaster

                ChartCheck {
                    you: root.you
                    text: "G Weaponmastery"
                    checked: you.grandmaster_grandweaponmastery
                    prop: "grandmaster_grandweaponmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Animal Mastery"
                    checked: you.grandmaster_animalmastery
                    prop: "grandmaster_animalmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Deliverance"
                    checked: you.grandmaster_deliverance
                    prop: "grandmaster_deliverance"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Assimilance"
                    checked: you.grandmaster_assimilance
                    prop: "grandmaster_assimilance"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "G Huntmastery"
                    checked: you.grandmaster_grandhuntmastery
                    prop: "grandmaster_grandhuntmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "G Pathsmanship"
                    checked: you.grandmaster_grandpathsmanship
                    prop: "grandmaster_grandpathsmanship"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-surge"
                    checked: you.grandmaster_kaisurge
                    prop: "grandmaster_kaisurge"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-screen"
                    checked: you.grandmaster_kaiscreen
                    prop: "grandmaster_kaiscreen"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Grand Nexus"
                    checked: you.grandmaster_grandnexus
                    prop: "grandmaster_grandnexus"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Telegnosis"
                    checked: you.grandmaster_telegnosis
                    prop: "grandmaster_telegnosis"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Magi-magic"
                    checked: you.grandmaster_magimagic
                    prop: "grandmaster_magimagic"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-alchemy"
                    checked: you.grandmaster_kaialchemy
                    prop: "grandmaster_kaialchemy"
                    width: disciplines.itemWidth
                }
            }

            SectionHeader {
                text: "Grand Weaponmastery Checklist"
                font.capitalization: Font.SmallCaps
                color: Theme.highlightColor
                visible: d.grandmaster
            }
            Grid { id: grandweaponmasterygrid
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.grandmaster
                property real itemWidth: (col.width - spacing) / 2
                Repeater { id: wprofrepeater
                    delegate: ChartCheck {
                        you: root.you
                        text: model.text
                        checked: you[model.prop]
                        prop: prop
                        width: grandweaponmasterygrid.itemWidth
                    }
                }
            }

            SectionHeader {
                text: "Grand Master Disciplines"
                font.capitalization: Font.SmallCaps
                visible: d.neworder
            }
            Grid {
                columns: 2
                rows: 8
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.neworder

                ChartCheck {
                    you: root.you
                    text: "G Weaponmastery"
                    checked: you.neworder_grandweaponmastery
                    prop: "neworder_grandweaponmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Animal Mastery"
                    checked: you.neworder_animalmastery
                    prop: "neworder_animalmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Deliverance"
                    checked: you.neworder_deliverance
                    prop: "neworder_deliverance"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Assimilance"
                    checked: you.neworder_assimilance
                    prop: "neworder_assimilance"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "G Huntmastery"
                    checked: you.neworder_grandhuntmastery
                    prop: "neworder_grandhuntmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "G Pathsmanship"
                    checked: you.neworder_grandpathsmanship
                    prop: "neworder_grandpathsmanship"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-surge"
                    checked: you.neworder_kaisurge
                    prop: "neworder_kaisurge"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-screen"
                    checked: you.neworder_kaiscreen
                    prop: "neworder_kaiscreen"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Grand Nexus"
                    checked: you.neworder_grandnexus
                    prop: "neworder_grandnexus"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Telegnosis"
                    checked: you.neworder_telegnosis
                    prop: "neworder_telegnosis"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Magi-magic"
                    checked: you.neworder_magimagic
                    prop: "neworder_magimagic"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Kai-alchemy"
                    checked: you.neworder_kaialchemy
                    prop: "neworder_kaialchemy"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Astrology"
                    checked: you.neworder_astrology
                    prop: "neworder_astrology"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Herbmastery"
                    checked: you.neworder_herbmastery
                    prop: "neworder_herbmastery"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Elementalism"
                    checked: you.neworder_elementalism
                    prop: "neworder_elementalism"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Bardsmanship"
                    checked: you.neworder_bardsmanship
                    prop: "neworder_bardsmanship"
                    width: disciplines.itemWidth
                }
            }

            SectionHeader {
                text: "Grand Weaponmastery Checklist"
                font.capitalization: Font.SmallCaps
                visible: d.neworder
            }
            Grid {
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.neworder

                ChartCheck {
                    you: root.you
                    text: "Dagger"
                    checked: you.neworder_grandweaponmastery_dagger
                    prop: "neworder_grandweaponmastery_dagger"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mace"
                    checked: you.neworder_grandweaponmastery_mace
                    prop: "neworder_grandweaponmastery_mace"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Warhammer"
                    checked: you.neworder_grandweaponmastery_warhammer
                    prop: "neworder_grandweaponmastery_warhammer"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Axe"
                    checked: you.neworder_grandweaponmastery_axe
                    prop: "neworder_grandweaponmastery_axe"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Quarterstaff"
                    checked: you.neworder_grandweaponmastery_quarterstaff
                    prop: "neworder_grandweaponmastery_quarterstaff"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Spear"
                    checked: you.neworder_grandweaponmastery_spear
                    prop: "neworder_grandweaponmastery_spear"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Short Sword"
                    checked: you.neworder_grandweaponmastery_shortsword
                    prop: "neworder_grandweaponmastery_shortsword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Bow"
                    checked: you.neworder_grandweaponmastery_bow
                    prop: "neworder_grandweaponmastery_bow"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Sword"
                    checked: you.neworder_grandweaponmastery_sword
                    prop: "neworder_grandweaponmastery_sword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Broadsword"
                    checked: you.neworder_grandweaponmastery_broadsword
                    prop: "neworder_grandweaponmastery_broadsword"
                    width: disciplines.itemWidth
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
                //height: Theme.itemSizeLarge
                text: you.notes
                placeholderText: "\n\n\n"
                visible: !d.neworder
                Binding {
                    target: you
                    property: "notes"
                    value: notes.text
                }
            }
            TextArea {
                id: neworder_notes
                //height: Theme.itemSizeLarge
                width: parent.width
                text: you.neworder_notes
                visible: d.neworder
                Binding {
                    target: you
                    property: "neworder_notes"
                    value: neworder_notes.text
                }
            }
        }
    }
}

