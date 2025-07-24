/*
 * This file is part of Lonewolf
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Sailfish.Silica 1.0

Image { id: root
    property string book
    property bool showIndex: true
    property bool mayDisplay: uisettings.licenseAccepted
    // Can not distribute local images, see Project AON license, and Issue #19
    //onBookChanged: if (book) { source = Qt.resolvedUrl("./covers/" + book + ".jpg") }
    source: (mayDisplay && book && (book != "29tsoc")) // 29 has no image
            ? "https://www.projectaon.org/data/trunk/en/jpeg/lw/" + book + "/skins/ebook/cover.jpg"
            : ""

    // all the cover images have this size:
    height: width/600*800
    sourceSize.width:  600
    sourceSize.height: 800
    fillMode: Image.PreserveAspectFit
    smooth: false; //cache: false

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: root.mayDisplay && parent.source && ((parent.status != Image.Ready) && (parent.status != Image.Error))
    }
    Rectangle {
        visible: root.showIndex
        height: parent.height*1/5
        width: height
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.paddingSmall
        radius: height/4
        color: Theme.lightPrimaryColor
        opacity: 0.75
        border.width: 2
        border.color: Theme.darkPrimaryColor

        Label {
            anchors.centerIn: parent
            text: root.showIndex ? index+1 : ""
            color: Theme.darkPrimaryColor
            opacity: 1.0
            font.pixelSize: parent.height*2/3
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
