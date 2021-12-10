import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {

    id:root
    anchors.fill: parent
    signal cancelPropagated()
    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
        id:ma
        anchors.fill: parent
    }

    Rectangle{
        anchors.fill:parent
        color: "lightblue"
        z:ma+1

        Text {
            anchors.centerIn: parent
            id: name
            text: qsTr("Graph page")
        }
    }
}
