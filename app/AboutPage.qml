/*
 * This file is part of Lonewolf
 * Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

Page { id: about

  readonly property string email: "mailto:sailfish@nephros.org?bcc=sailfish+app@nephros.org&subject=A%20message%20from%20a%20" + Qt.application.name + "%20user&body=Hello%20nephros%2C%0A"
  readonly property string license: "GPLv3"
  readonly property string source: "https://github.com/nephros/lonewolf"
  readonly property string portsource: "https://github.com/mikix/kaichronicles"
  readonly property string origsource: "https://github.com/timsueberkrueb/lonewolf"

  SilicaFlickable {
    contentHeight: col.height + Theme.itemSizeLarge
    anchors.fill: parent
    VerticalScrollDecorator {}
    Column {
        id: col
        width: parent.width - Theme.horizontalPageMargin
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingLarge
        PageHeader { title: "About" }
        Label {
            width: icon.width
            anchors.horizontalCenter: icon.horizontalCenter
            text: "Lone Wolf"
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignHCenter
        }
        Image { id: icon
            anchors.horizontalCenter: parent.horizontalCenter
            source: "image://theme/" + Qt.application.name
            height: Theme.iconSizeExtraLarge
            width: height
        }
        Label {
            width: icon.width
            anchors.horizontalCenter: icon.horizontalCenter
            text: Qt.application.version
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "This is a fork of Lonewolf by Tim Süberkrüb, which is a fork of Michael Terry's Kai Chronicals app for Ubuntu Phone.\n\nPorted to Sailfish OS by nephros."
        }
        DetailItem { label: qsTr("License:");          value: license }
        DetailItem { label: qsTr("Source Code:");      value: source;     BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(source) } }
        DetailItem { label: qsTr("Tim's Code:");       value: origsource; BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(origsource) } }
        DetailItem { label: qsTr("Michael's  Code:");  value: portsource; BackgroundItem { anchors.fill: parent; onClicked: Qt.openUrlExternally(portsource) } }

        SectionHeader { text: "Additional Features" }
        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            linkColor: Theme.primaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "<b>Text-to-Speech:</b><p>If you have installed and configured <a href='https://openrepos.net/content/mkiol/speech-note'>Speech Note</a> by <tt>mkiol</tt>, you can search the 3rd party app stores for “TTS plugin for Lonewolf”. This will enable this feature for the existing installation.</p>"
                + "<p>Unfortunately we can not ship this in the Harbour version of this app.</p>"
        }
        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "<b>Display Font:</b><p>The original books were printed using the “Souvenir” typeface. Since no freely distributable version of this font could be found (hints welcome!), we can not provide it with the app. Instead, we ship the free font “Alegreya” which looks somewhat similar.</p>"
                + "<p>If you happen to have the original (non-free) “Souvenir”, “ITC Souvenir”, or “AG Souvenir” fonts installed, they will be used automatically.</p>"
                + "<p>Below you can see a comparison of Alegreya (top) and Souvenir (bottom)</p>"
        }
        Image {
            width: parent.width*8/10
            anchors.horizontalCenter: parent.horizontalCenter
            source: "demo_souvenir.png"
            fillMode: Image.PreserveAspectFit
        }
        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "<p>You can also use fontconfig to define an alias called <b>lone-wolf</b>, whatever you set as a font there will be used for the Book pages.</p>"
        }
        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            linkColor: Theme.primaryColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignJustify
            wrapMode: Text.WordWrap
            text: "<b>Cheating:</b><p>As said in the app description, playing “relies on the honor system a bit”. So you do yourself no favour by trying it.</p>"
                + "<p>However, backing up and restoring a save state (also known as “Save Scumming”) is possible, and a script to do so is provided in the app installation directory.</p>"
                + "<p>No such feature will ever be implemented in the app itself however.</p>"
        }
     }
  }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
