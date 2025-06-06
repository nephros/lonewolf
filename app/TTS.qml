/*
 * SPDX-FileCopyrightText: Copyright (c) 2025 Peter G. (nephros)
 * SPDX-License-Identifier: GPLv3
 */
import QtQuick 2.6
import Nemo.DBus 2.0

Item { id: root
    property bool speaking: false
    property int speakId
    property int serviceState
    property int taskState

    onSpeakingChanged: {
        if (!speaking) speakId = -1
        //console.info("TTS:" + (speaking ? " began " : " stopped " ) + "speaking.")
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
        const toSpeak = cleanText(text)
        if (speaking) {
            console.debug("TTS: Stopping job before submitting new one!:")
            dbus.call("TtsStopSpeech", [ speakId ],
                function(r) { reallyPlay(toSpeak);  },
                undefined
            )
        } else {
            reallyPlay(toSpeak)
        }
    }
    function reallyPlay(text) {
        dbus.call("TtsPlaySpeech", [ text, "en" ],
        // available settings: split_into_sentences, use_engine_speed_control, normalize_audio, speech_speed
        //dbus.typedcall("TtsPlaySpeech2", [
        //        { "type" : 's', "value": text },
        //        { "type" : 's', "value": "en"} ,
        //        { "type" : 'a{sv}',
        //          "value": { "split_into_sentences": false, "use_engine_speed_control": true, "normalize_audio": false, "speech_speed": 12 }
        //        },
        //    ],
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
        if (speakId < 0) { console.debug("TTS: No valid job stored in our tracker. Doing nothing"); return }
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
        function ttsPlaySpeechFinished(task) {
            console.debug("TTS: Speech job finished:", task)
            if (task == root.speakId) root.speaking = false
        }
        function errorOccured(code) {
            console.warn("TTS: Speech error:", code, ",", errorCodeTable[code])
            root.speaking = false
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
            console.debug("TTS: State now:", stateTable[code])
            root.serviceState = code
            if (code == 3) {root.speaking = false}
            if (code == 8) {root.speaking = true}
        }
        function taskStatePropertyChanged(code) {
            root.taskState = code
            console.debug("TTS: Task now:", taskStateTable[code])
            if ((code > 1) && (code < 5)) {root.speaking = true}
        }
        propertiesEnabled: false
        //property int state
        //onStateChanged: console.debug("TTS: State property change:", state, ",", stateTable[state])
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
