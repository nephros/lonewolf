/*
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Nemo.DBus 2.0

Item { id: root
    // https://github.com/mkiol/dsnote/blob/main/dbus/org.mkiol.Speech.xml
    /*
        <method name="TtsPlaySpeech">
            <arg name="text" type="s" direction="in" />
            <arg name="lang" type="s" direction="in" />
            <arg name="task" type="i" direction="out" />
        </method>
    */
    function play(text) {
        dbus.call("TtsPlaySpeech", [ text, "en" ],
            function(r) {},
            function(e,m) { console.warn("Error:", e, m) }
        )
    }
    DBusInterface { id: dbus
        iface: "org.mkiol.Speech"
        service: "org.mkiol.Speech"
        path: "/org/mkiol/Speech"
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
