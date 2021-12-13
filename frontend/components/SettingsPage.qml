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
        anchors.fill: parent
    }

    Rectangle{
        id:header
        anchors.fill: parent
        color: Style.colorReal

        Button{
            id:sett
            anchors{
                bottom: parent.bottom
                left: parent.left
            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf060"
            font.family: Style.fontAwesomeLight
            onClicked: cancelPropagated()


        }

        Text {
            id: name
            anchors{
                bottom: parent.bottom
                verticalCenter: sett.verticalCenter
                left: sett.right
            }

            color: "white"
            text: qsTr("Settings")
            font.pixelSize: Style.smallTinyFontSize
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

        }

        Component.onCompleted: {
            if(Style.wHeight > Style.wWidth){ //portrait
                height = Qt.binding(function(){return (1/9 * Style.wHeight) < 80 ? 80 : (1/9 * Style.wHeight) })
            } else { //landscape
                height = Qt.binding(function(){return (1/5 * Style.wHeight) < 65 ? 65 : (1/5 * Style.wHeight)})
            }
        }

        onHeightChanged: {
            if(Style.wHeight > Style.wWidth){ //portrait
                height = Qt.binding(function(){return (1/9 * Style.wHeight) < 80 ? 80 : (1/9 * Style.wHeight) })
            } else { //landscape
                height = Qt.binding(function(){return (1/5 * Style.wHeight) < 65 ? 65 : (1/5 * Style.wHeight)})
            }
        }
    }

    Rectangle{
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }




    }
}
