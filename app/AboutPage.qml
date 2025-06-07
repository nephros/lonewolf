/*
 * This file is part of Lonewolf
 * Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

Page { id: about

  //readonly property string copyright: "Peter G. (nephros)"
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
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "image://theme/lonewolf"
            height: Theme.iconSizeExtraLarge
            width: height
        }
        Label {
            text: "Lone Wolf is a role-playing book series from the 80s.\nThis is a fork of Lonewolf by Tim Süberkrüb, which is a fork of Michael Terry's Lone Wolf app for Ubuntu Phone.\nPorted to Sailfish OS by nephros."
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            wrapMode: Text.Wrap
        }
        //DetailItem { label: }
    }
  }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
