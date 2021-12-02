import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {

    signal settingsButtonClicked()
    property int pheight

    id:root
    anchors.left: parent.left
    anchors.right: parent.right

    Component.onCompleted: {
        if(pheight > root.width){ //portrait
            height = Qt.binding(function(){return 1/10 * pheight})
        } else { //landscape
            height = Qt.binding(function(){return 1/5 * pheight})
        }
    }

    onHeightChanged: {
        if(pheight > root.width){ //portrait
            height = Qt.binding(function(){return 1/10 * pheight})
        } else { //landscape
            height = Qt.binding(function(){return 1/5 * pheight})
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
                rightMargin: Style.margin
            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf1de"
            font.family: Style.fontAwesome
            onClicked: settingsButtonClicked()


        }

    }
}
