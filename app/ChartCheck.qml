import QtQuick 2.4
import Sailfish.Silica 1.0

Row {
    property var you
    property string prop
    property alias checked: box.checked
    property alias text: label.text
    Binding {
        target: you
        property: prop
        value: box.checked
    }
    Switch {
        id: box
        anchors.verticalCenter: parent.verticalCenter
    }
    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
    }
}

