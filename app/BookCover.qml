/*
 * This file is part of Lonewolf
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Sailfish.Silica 1.0

Image { id: root
    property string book
    onBookChanged: if (book) { source = "https://www.projectaon.org/data/trunk/en/jpeg/lw/" + book + "/skins/ebook/cover.jpg" }
    height: width/600*800
    sourceSize.width:600
    sourceSize.height:800
    fillMode: Image.PreserveAspectFit
    smooth: false; //cache: false

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: parent.book && (parent.status != Image.Ready)
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
