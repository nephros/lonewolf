/*
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Nemo.DBus 2.0

Item { id: root
    property bool speaking: false
    property int speakId
    onSpeakingChanged: {
        if (!speaking) speakId = -1
        console.info("TTS:" + (speaking ? " began " : " stopped " ) + "speaking.")
    }
    // https://github.com/mkiol/dsnote/blob/main/dbus/org.mkiol.Speech.xml
    /*
        <method name="TtsPlaySpeech">
            <arg name="text" type="s" direction="in" />
            <arg name="lang" type="s" direction="in" />
            <arg name="task" type="i" direction="out" />
        </method>
    */
    function cleanText(text) {
        const newText
        newText = text.replace(/[ \n]+/g, ' ')
        return newText
    }
    function play(text) {
        if (speaking) return
        const toSpeak = cleanText(text)
        dbus.call("TtsPlaySpeech", [ toSpeak, "en" ],
            function(tid) {
                if (tid < 0) { 
                    console.warn("TTS: Speech job ID < 0 indicates an error!")
                    root.speaking = false
                } else {
                    console.debug("TTS: Speech job submitted:", tid ); root.speaking = true; root.speakId = tid
                }
            },
            function(e,m) { console.warn("TTS: Speech job Error:", e, m) }
        )
    }
    function stop() {
        if (!speaking) return
        dbus.call("TtsStopSpeech", [ speakId ],
            function(r)   { console.debug("TTS: Stop job submitted:", r) },
            function(e,m) { console.warn("TTS: Stopping Error:", e, m) }
        )
    }
    DBusInterface { id: dbus
        iface: "org.mkiol.Speech"
        service: "org.mkiol.Speech"
        path: "/"
        signalsEnabled: true
        // Signals from "org.mkiol.Speech"
        function ttsPlaySpeechFinished(tid) {
            console.debug("TTS: Speech job finished:", tid)
            if (tid == root.speakId) root.speaking = false
        }
        function errorOccured(code) {
            console.warn("TTS: Speech error:", code)
            root.speaking = false
        }
    }
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
