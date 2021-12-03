import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {
    signal editButtonClicked()
    signal deleteButtonClicked()
    property bool toggleSubmenu: true

    id:root

    anchors.left: parent.left
    anchors.right: parent.right
    visible: toggleSubmenu


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

    Rectangle{
        anchors.fill: parent
        color: Qt.darker(Style.colorReal)


        Text {
            id: name
            anchors{
                bottom: parent.bottom
                bottomMargin: Style.margin *.5
            }

            width: 1/2 * parent.width
            color: "white"
            text: qsTr("Warehouse Monitor")
            font.pixelSize: Style.mediumFontSize
            font.family: Style.corsiva
            font.bold: true
            horizontalAlignment: Text.AlignHCenter

        }


        Button{
            id:deletebutton
            anchors{
                bottom: parent.bottom
                right: parent.right
                rightMargin: Style.margin
            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf2ed"
            font.family: Style.fontAwesomeLight
            onClicked: deleteButtonClicked()


        }


        Button{
            id:editbutton
            anchors{
                bottom: parent.bottom
                right: deletebutton.left

            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf044"
            font.family: Style.fontAwesomeLight
            onClicked: editButtonClicked()


        }


    }

}
