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
        : Theme.highlightDimmerFromColor("#333300", Theme.colorScheme)

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
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: parent.width*4/5
        height: parent.height/3
        opacity: 0.8
        cache: true; smooth: false
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
                verticalItemAlignment: Grid.AlignVCenter
                columnSpacing: Theme.paddingSmall
                rowSpacing: Theme.paddingSmall

                Label {
                    text: "Combat Skill"
                    color: Theme.highlightColor
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
                    text: "Endurance"
                    color: Theme.highlightColor
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
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_endurance +=1 : you.endurance +=1
                    }
                }

                Label {
                    text: "Max Endurance"
                    color: Theme.highlightColor
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
                Item {height: 1; width: 1}

                Label {
                    text: "Belt Pouch"
                    color: Theme.highlightColor
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
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_gold +=1 : you.gold +=1
                    }
                }
                Label {
                    text: "Quiver"
                    color: Theme.highlightColor
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
                    }
                    IconButton {
                        width: Theme.buttonWidthTiny
                        icon.source: "image://theme/icon-splus-add"
                        onClicked: d.neworder ? you.neworder_meals +=1 : you.meals +=1
                    }
                }
            }

            Item {
                width: 1
                height: 1
            }
            SectionHeader {
                text: "Weapons"
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

            Item {
                width: 1
                height: 1
            }
            SectionHeader {
                text: "Backpack Items (%1 meals: %2 free)".arg(meals).arg(slots)
                property int meals: d.neworder ? you.neworder_meals : you.meals
                property int slots: 8 - meals
            }
            Grid {
                id: backpack
                columns: 2
                rows: 5
                flow: Grid.LeftToRight
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                visible: !d.neworder

                ChartItem {
                    text: you.backpack1
                    you: root.you
                    prop: "backpack1"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack2
                    you: root.you
                    prop: "backpack2"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack3
                    you: root.you
                    prop: "backpack3"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack4
                    you: root.you
                    prop: "backpack4"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack5
                    you: root.you
                    prop: "backpack5"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack6
                    you: root.you
                    prop: "backpack6"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack7
                    you: root.you
                    prop: "backpack7"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack8
                    you: root.you
                    prop: "backpack8"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.backpack9
                    you: root.you
                    prop: "backpack9"
                    width: backpack.itemWidth
                    visible: d.grandmaster
                }
                ChartItem {
                    text: you.backpack10
                    you: root.you
                    prop: "backpack10"
                    width: backpack.itemWidth
                    visible: d.grandmaster
                }
            }
            Grid {
                id: neworder_backpack
                columns: 2
                rows: 5
                flow: Grid.LeftToRight
                spacing: 1
                visible: d.neworder

                ChartItem {
                    text: you.neworder_backpack1
                    you: root.you
                    prop: "neworder_backpack1"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack2
                    you: root.you
                    prop: "neworder_backpack2"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack3
                    you: root.you
                    prop: "neworder_backpack3"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack4
                    you: root.you
                    prop: "neworder_backpack4"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack5
                    you: root.you
                    prop: "neworder_backpack5"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack6
                    you: root.you
                    prop: "neworder_backpack6"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack7
                    you: root.you
                    prop: "neworder_backpack7"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack8
                    you: root.you
                    prop: "neworder_backpack8"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack9
                    you: root.you
                    prop: "neworder_backpack9"
                    width: backpack.itemWidth
                }
                ChartItem {
                    text: you.neworder_backpack10
                    you: root.you
                    prop: "neworder_backpack10"
                    width: backpack.itemWidth
                }
            }

            Item {
                width: 1
                height: 1
                visible: d.neworder
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

            Item {
                width: 1
                height: 1
            }
            SectionHeader {
                text: "Special Items"
            }
            Grid {
                id: specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: col.width
                visible: !d.neworder

                ChartItem {
                    text: you.special1
                    you: root.you
                    prop: "special1"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special2
                    you: root.you
                    prop: "special2"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special3
                    you: root.you
                    prop: "special3"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special4
                    you: root.you
                    prop: "special4"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special5
                    you: root.you
                    prop: "special5"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special6
                    you: root.you
                    prop: "special6"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special7
                    you: root.you
                    prop: "special7"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special8
                    you: root.you
                    prop: "special8"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special9
                    you: root.you
                    prop: "special9"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special10
                    you: root.you
                    prop: "special10"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special11
                    you: root.you
                    prop: "special11"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.special12
                    you: root.you
                    prop: "special12"
                    width: specials.itemWidth
                }
            }
            Grid {
                id: neworder_specials
                columns: 1
                rows: 12
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.neworder

                ChartItem {
                    text: you.neworder_special1
                    you: root.you
                    prop: "neworder_special1"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special2
                    you: root.you
                    prop: "neworder_special2"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special3
                    you: root.you
                    prop: "neworder_special3"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special4
                    you: root.you
                    prop: "neworder_special4"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special5
                    you: root.you
                    prop: "neworder_special5"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special6
                    you: root.you
                    prop: "neworder_special6"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special7
                    you: root.you
                    prop: "neworder_special7"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special8
                    you: root.you
                    prop: "neworder_special8"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special9
                    you: root.you
                    prop: "neworder_special9"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special10
                    you: root.you
                    prop: "neworder_special10"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special11
                    you: root.you
                    prop: "neworder_special11"
                    width: specials.itemWidth
                }
                ChartItem {
                    text: you.neworder_special12
                    you: root.you
                    prop: "neworder_special12"
                    width: specials.itemWidth
                }
            }

            Item {
                width: 1
                height: 1
                visible: d.kai
            }
            SectionHeader {
                text: "Kai Disciplines"
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
                    }, 5) // start at "Initiate"
                    return r
                }
            }
            Grid {
                id: disciplines
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                property real itemWidth: (col.width - spacing) / 2
                visible: d.kai

                ChartCheck {
                    you: root.you
                    text: "Camouflage"
                    checked: you.kai_camouflage
                    prop: "kai_camouflage"
                    note: "Blend in with your surroundings"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Hunting"
                    checked: you.kai_hunting
                    prop: "kai_hunting"
                    note: "Skip a meal in certain areas"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Sixth Sense"
                    checked: you.kai_sixthsense
                    prop: "kai_sixthsense"
                    note: "Warns about imminent danger"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Tracking"
                    checked: you.kai_tracking
                    prop: "kai_tracking"
                    note: "Find the right path"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Healing"
                    checked: you.kai_healing
                    prop: "kai_healing"
                    note: "+1 EP for each section without combat"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Weaponskill"
                    checked: you.kai_weaponskill
                    prop: "kai_weaponskill"
                    note: "+2 CS for with chosen weapon"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mindshield"
                    checked: you.kai_mindshield
                    prop: "kai_mindshield"
                    note: "Immune to Mindblast attack"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mindblast"
                    checked: you.kai_mindblast
                    prop: "kai_mindblast"
                    note: "+2 CS against most enemies"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Animal Kinship"
                    checked: you.kai_animalkinship
                    prop: "kai_animalkinship"
                    note: "Communiate with some animals"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mind Over Matter"
                    checked: you.kai_mindovermatter
                    prop: "kai_mindovermatter"
                    note: "Move small objects with your mind"
                    width: disciplines.itemWidth
                }
            }

            ChartItem {
                text: you.weaponskill_weapon
                you: root.you
                prop: "weaponskill_weapon"
                width: parent.width
                description: "Weaponskill Weapon"
                visible: d.kai
            }

            SectionHeader { text: "Magnakai Disciplines" }
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
                        }, 3) // start at "Kai Master Superior"
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
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.magnakai

                ChartCheck {
                    you: root.you
                    text: "Weaponmastery"
                    checked: you.magnakai_weaponmastery
                    prop: "magnakai_weaponmastery"
                    note: "+3 CS for with chosen weapon"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Animal Control"
                    checked: you.magnakai_animalcontrol
                    prop: "magnakai_animalcontrol"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Curing"
                    checked: you.magnakai_curing
                    prop: "magnakai_curing"
                    note: "+1 EP for each section without combat"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Invisibility"
                    checked: you.magnakai_invisibility
                    prop: "magnakai_invisibility"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Huntmastery"
                    checked: you.magnakai_huntmastery
                    prop: "magnakai_huntmastery"
                    note: "Skip a meal requirement"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Pathsmanship"
                    checked: you.magnakai_pathsmanship
                    prop: "magnakai_pathsmanship"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Psi-surge"
                    checked: you.magnakai_psisurge
                    prop: "magnakai_psisurge"
                    note: "+4CS/-2 EP, or +2CS per round of combat"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Psi-screen"
                    checked: you.magnakai_psiscreen
                    prop: "magnakai_psiscreen"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Nexus"
                    checked: you.magnakai_nexus
                    prop: "magnakai_nexus"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Divination"
                    checked: you.magnakai_divination
                    prop: "magnakai_divination"
                    width: disciplines.itemWidth
                }
            }

            Item {
                width: 1
                height: 1
                visible: d.magnakai
            }
            SectionHeader {
                text: "Weaponmastery Checklist"
                color: Theme.highlightColor
                visible: d.magnakai
            }
            Grid {
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.magnakai

                ChartCheck {
                    you: root.you
                    text: "Dagger"
                    checked: you.weaponmastery_dagger
                    prop: "weaponmastery_dagger"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mace"
                    checked: you.weaponmastery_mace
                    prop: "weaponmastery_mace"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Warhammer"
                    checked: you.weaponmastery_warhammer
                    prop: "weaponmastery_warhammer"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Axe"
                    checked: you.weaponmastery_axe
                    prop: "weaponmastery_axe"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Quarterstaff"
                    checked: you.weaponmastery_quarterstaff
                    prop: "weaponmastery_quarterstaff"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Spear"
                    checked: you.weaponmastery_spear
                    prop: "weaponmastery_spear"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Short Sword"
                    checked: you.weaponmastery_shortsword
                    prop: "weaponmastery_shortsword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Bow"
                    checked: you.weaponmastery_bow
                    prop: "weaponmastery_bow"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Sword"
                    checked: you.weaponmastery_sword
                    prop: "weaponmastery_sword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Broadsword"
                    checked: you.weaponmastery_broadsword
                    prop: "weaponmastery_broadsword"
                    width: disciplines.itemWidth
                }
            }

            Item {
                width: 1
                height: 1
                visible: d.grandmaster
            }
            SectionHeader {
                text: "Grand Master Disciplines"
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

            Item {
                width: 1
                height: 1
                visible: d.grandmaster
            }
            SectionHeader {
                text: "Grand Weaponmastery Checklist"
                color: Theme.highlightColor
                visible: d.grandmaster
            }
            Grid {
                columns: 2
                rows: 5
                flow: Grid.TopToBottom
                spacing: 1
                visible: d.grandmaster

                ChartCheck {
                    you: root.you
                    text: "Dagger"
                    checked: you.grandweaponmastery_dagger
                    prop: "grandweaponmastery_dagger"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Mace"
                    checked: you.grandweaponmastery_mace
                    prop: "grandweaponmastery_mace"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Warhammer"
                    checked: you.grandweaponmastery_warhammer
                    prop: "grandweaponmastery_warhammer"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Axe"
                    checked: you.grandweaponmastery_axe
                    prop: "grandweaponmastery_axe"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Quarterstaff"
                    checked: you.grandweaponmastery_quarterstaff
                    prop: "grandweaponmastery_quarterstaff"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Spear"
                    checked: you.grandweaponmastery_spear
                    prop: "grandweaponmastery_spear"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Short Sword"
                    checked: you.grandweaponmastery_shortsword
                    prop: "grandweaponmastery_shortsword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Bow"
                    checked: you.grandweaponmastery_bow
                    prop: "grandweaponmastery_bow"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Sword"
                    checked: you.grandweaponmastery_sword
                    prop: "grandweaponmastery_sword"
                    width: disciplines.itemWidth
                }
                ChartCheck {
                    you: root.you
                    text: "Broadsword"
                    checked: you.grandweaponmastery_broadsword
                    prop: "grandweaponmastery_broadsword"
                    width: disciplines.itemWidth
                }
            }

            Item {
                width: 1
                height: 1
                visible: d.neworder
            }
            SectionHeader {
                text: "Grand Master Disciplines"
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

            Item {
                width: 1
                height: 1
                visible: d.neworder
            }
            SectionHeader {
                text: "Grand Weaponmastery Checklist"
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

            Item {
                width: 1
                height: 1
            }
            Label {
                text: "Notes"
                color: Theme.highlightColor
            }
            TextArea {
                id: notes
                width: parent.width
                //height: Theme.itemSizeLarge
                text: you.notes
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

