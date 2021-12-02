import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {

    signal addNewDevice()

    id:root
    anchors.left: parent.left
    anchors.right: parent.right

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
        color: Style.colorReal

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
            anchors{
                bottom: parent.bottom
                right: parent.right
            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf39c"
            font.family: Style.fontAwesome
            onClicked: menu.open()

            Menu {

                id: menu
                topPadding: 0
                bottomPadding: 0
                x:-menu.width * .7


                MenuItem {
                    text: "Add New Device"
                    onCanceled: highlighted = false
                    onTriggered: {
                        highlighted = false
                        addNewDevice()
                    }


                }

                MenuItem {
                    text: "Quit Application"
                    onCanceled: highlighted = false
                    onTriggered: {
                        highlighted = false
                        Qt.quit()

                    }


                }


            }

        }
    }
}
