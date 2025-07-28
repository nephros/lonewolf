import QtQuick 2.4
import Sailfish.Silica 1.0

Row {
    property var you
    property string prop
    property alias checked: box.checked
    property alias text: box.text
    property alias note: box.description
    Binding {
        target: you
        property: prop
        value: box.checked
    }
    TextSwitch {
        id: box
        anchors.verticalCenter: parent.verticalCenter
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4 syntax=qml
