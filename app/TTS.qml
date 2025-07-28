/*
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Nemo.DBus 2.0

Item { id: root
    property bool ready: (dbus.status == DBusInterface.Available)
    property bool speaking: false
    property bool idle: false
    property int speakId
    property int serviceState
    property int taskState

    onSpeakingChanged: {
        if (!speaking) speakId = -1
    }
    property alias keepaliveInterval: keepalive.interval
    // we need to keep the speech going
    Timer { id: keepalive
        interval: 2000
        repeat: true
        onTriggered: root.wakeTask()
    }
    function wakeTask() {
        //console.warn("TTS: Timer Speech keepalive", root.speakId, interval)
        dbus.call("KeepAliveTask", [ root.speakId ],
            function(m) {
                 //console.debug("TTS: Speech keepalive", m)
                 if (m == 0) { keepaliveInterval = 2000; keepalive.stop() }
                 else { keepaliveInterval = Math.max(2000, m/2) }
            },
            function(e,m) { console.warn("TTS: Speech keepalive Error:", e, m) }
        )
    }

    function wakeService() {
        dbus.call("KeepAliveService", [ ])
    }

    function cleanText(text) {
        const newText
        newText = text.replace(/[ \n]+/g, ' ')
        return newText
    }
    function play(text) {
        if (speaking || !idle) {
            console.warn("TTS: Not idle, not submitting new job!")
        } else {
            const toSpeak = cleanText(text)
            reallyPlay(toSpeak)
        }
    }
    function reallyPlay(text) {
        // https://github.com/mkiol/dsnote/blob/main/dbus/org.mkiol.Speech.xml
        /*
            <method name="TtsPlaySpeech">
                <arg name="text" type="s" direction="in" />
                <arg name="lang" type="s" direction="in" />
                <arg name="task" type="i" direction="out" />
            </method>
        */
        //dbus.call("TtsPlaySpeech", [ text, "en" ],
        // available settings: split_into_sentences, use_engine_speed_control, normalize_audio, speech_speed
        dbus.typedCall("TtsPlaySpeech2", [
                { "type" : 's', "value": text },
                { "type" : 's', "value": "en"} ,
                { "type" : 'a{sv}',
                  "value": [ { "split_into_sentences": false,
                               "use_engine_speed_control": true,
                               "normalize_audio": false,
                               "speech_speed": 15 // 1- 20???
                             }
                  ],
                },
            ],
            function(task) {
                if (task < 0) {
                    console.warn("TTS: Speech job ID < 0 indicates an error!")
                    root.speaking = false
                } else {
                    //console.debug("TTS: Speech job submitted:", tid ); root.speaking = true; root.speakId = tid
                    root.speakId = task
                }
            },
            function(e,m) { console.warn("TTS: Speech job Error:", e, m) }
        )
    }
    function stop() {
        if (speakId < 0) { console.debug("TTS: No valid job stored in our tracker. Doing nothing"); return }
        dbus.call("TtsStopSpeech", [ speakId ],
            function(r)   { console.debug("TTS: Stop job submitted:", r) },
            function(e,m) { console.warn("TTS: Stopping Error:", e, m) }
        )
    }
    Component.onCompleted: { fdo.call("Ping", []) }
    //Component.onCompleted: { console.debug("One Ping, Vassili!"); fdo.call("Ping", []) }
    DBusInterface { id: fdo
        iface: "org.freedesktop.DBus.Peer"
        service: "org.mkiol.Speech"
        path: "/"
    }
    DBusInterface { id: dbus
        iface: "org.mkiol.Speech"
        service: "org.mkiol.Speech"
        path: "/"
        signalsEnabled: true
        propertiesEnabled: true
        watchServiceStatus: true
        onStatusChanged: {
            //console.debug("TTS: DBus status", dbus.status)
            if (dbus.status == DBusInterface.Available) {
                console.debug("TTS: DBus available.")
            } else {
                console.debug("TTS: DBus not available.")
            }
        }
        // Signals from "org.mkiol.Speech"
        function ttsPlaySpeechFinished(task) {
            //console.debug("TTS: Speech job finished:", task)
            if (task == root.speakId) root.speaking = false
        }
        function errorOccured(code) {
            console.warn("TTS: Speech error:", code, ",", errorCodeTable[code])
            root.speaking = false
        }
        function ttsPartialSpeechPlaying(text, task) {
            console.debug("TTS: Partial task:", task, text)
            if (task == root.speakId) { 
                root.speaking = true
                root.wakeTask()
            }
        }
        /*
            State of the service.
            Valid states: 0 = Unknown, 1 = Not Configured, 2 = Busy,
                          3 = Idle, 4 = Listening Manual, 5 = Listening Auto,
                          6 = Transcribing File, 7 = Listening One-sentence,
                          8 = Playing speech, 9 = Writing speech synthesis to file,
                          10 = Translating, 11 = Repairing text
            Unrecognized states should be considered equal to Unknown.
        */
        function statePropertyChanged(code) {
            //console.debug("TTS: State now:", stateTable[code])
            root.serviceState = code
            root.idle = (code == 3)
        }
        function taskStatePropertyChanged(code) {
            root.taskState = code
            root.speaking = (code != 0)
        }
    }
    readonly property var errorCodeTable: [
        "Generic",
        "Microphone error",
        "File source error",
        "STT engine",
        "TTS engine",
    ]
    readonly property var taskStateTable: [
        "Idle",
        "Speech Detected",
        "Processing",
        "Initializing",
        "Playing Speech",
        "Speech Paused",
        "Cancelling",
    ]
    readonly property var stateTable: [
        "Unknown",
        "Not Configured",
        "Busy",
        "Idle",
        "Listening Manual",
        "Listening Auto",
        "Transcribing File",
        "Listening One-sentence",
        "Playing speech",
        "Writing speech synthesis to file",
        "Translating",
        "Repairing text"
    ]
}

// vim: filetype=javascript syntax=qml expandtab tabstop=4 shiftwidth=4
