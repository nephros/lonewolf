/*
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Nemo.DBus 2.0

Item { id: root
    property bool ready: (dbus.status == DBusInterface.Available)
    property bool paused: false // TODO
    property bool speaking: false
    property bool idle: true // assume idle at start, until we hear a signal
    property int currentTask

    Timer { id: kickservice
        running: root.idle && (Qt.application.state === Qt.ApplicationActive)
        interval: 50000 // service default: 60s
        repeat: true
        onTriggered: wakeService()
        //onRunningChanged: console.debug("TTS: Service keepalive timer " + (running ? "started" : "stopped" ))
    }
    // we need to keep the speech going
    Timer { id: keepalive
        running: root.speaking && (currentTask >= 0)
        interval: 500
        repeat: true
        onTriggered: wakeTask()
        onRunningChanged: console.debug("TTS: Task keepalive timer " + (running ? "started" : "stopped" ))
        //onIntervalChanged: console.debug("TTS: Task keepalive interval" , interval)
    }
    // Call Ping to initialize, query properties when successful:
    Component.onCompleted: { peer.call("Ping", [], function() { console.debug("Pong") }) }
    function wakeTask() {
        //console.warn("TTS: Task keepalive", root.currentTask)
        dbus.call("KeepAliveTask", [ root.currentTask ],
            function(m) {
                 keepalive.interval = (m == 0) ? 500 : Math.max(500, Math.floor(m*0.8))
            },
            function(e,m) { console.warn("TTS: Speech keepalive Error:", e, m) }
        )
    }

    function wakeService() {
        if (ready) {
            dbus.call("KeepAliveService", [ ],
            function(m) {
                console.debuf("TTS: Service will shutdown in", m)
            //     keepalive.interval = (m == 0) ? 500 : Math.max(500, m/2)
            }
            )
        }
    }

    function cleanText(text) {
        const newText
        newText = text.replace(/[ \n]+/g, ' ')
        return newText
    }
    function play(text) {
        if (speaking || !idle) {
            console.warn("TTS: Not idle, not submitting new task!")
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
                               "speech_speed": 11 // 1- 20???
                             }
                  ],
                },
            ],
            function(task) {
                if (task < 0) {
                    console.warn("TTS: Speech task ID < 0 indicates an error!")
                }
                root.currentTask = task
            },
            function(e,m) { console.warn("TTS: Speech task Error:", e, m) }
        )
    }
    function stop() {
        dbus.call("TtsStopSpeech", [ currentTask ],
            function(r)   { },
            function(e,m) { console.warn("TTS: Stopping Error:", e, m) }
        )
    }
    // This is here so we can call the Ping method
    DBusInterface { id: peer
        iface: "org.freedesktop.DBus.Peer"
        service: "org.mkiol.Speech"
        path: "/"
    }
    DBusInterface { id: dbus
        iface: "org.mkiol.Speech"
        service: "org.mkiol.Speech"
        path: "/"
        signalsEnabled: true
        //propertiesEnabled: true
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
        /*
        function ttsPlaySpeechFinished(task) {
            console.debug("TTS: Speech task finished:", task)
            //if (task == root.currentTask) { root.speaking = false }
            else { console.debug("TTS: Finished signal for unknown id:", task) }
        }
        function errorOccured(code) {
            console.warn("TTS: Speech error:", code, ",", errorCodeTable[code])
            //if ((errorCodeTable[code] == "TTS engine") || (errorCodeTable[code] == "Generic"))
            //    root.speaking = false
        }
        */
        function ttsPartialSpeechPlaying(text, task) {
            //console.debug("TTS: Partial task:", task, text)
            root.currentTask = task
            root.speaking = true
            root.wakeTask()
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
            console.debug("TTS: Service state now:", stateTable[code])
            root.idle = (code == 3)
            root.speaking = (code == 9)
        }
        /*
        function taskStatePropertyChanged(code) {
            console.debug("TTS: Task now:", taskStateTable[code])
            root.speaking = (code > 0) && (code != 6) // will not report back after Cancelling
        }
        */
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
