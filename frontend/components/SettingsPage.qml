import QtQuick 2.0

Item {
    id:root
    anchors.fill: parent
    signal cancelPropagated()

    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
     anchors.fill: parent
     onCanceled: console.log("")
    }

    Rectangle{
        anchors.fill: parent
        color: "orange"

        Text {
            anchors.centerIn: parent
            id: name
            text: qsTr("settings page")
        }
    }

}
