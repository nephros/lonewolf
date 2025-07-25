import QtQuick 2.4
import Sailfish.Silica 1.0

TextField {
    property var you
    property string prop
    labelVisible: false
    Binding {
        target: you
        property: prop
        value: text
    }
    EnterKey.onClicked: focus = false
}

