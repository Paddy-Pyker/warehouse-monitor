import QtQuick 2.9
import QtQuick.Controls 2.5
import assets 1.0

Item {

    id:root
    anchors.left: parent.left
    anchors.right: parent.right

    Component.onCompleted: {
        if(Style.wHeight > Style.wWidth){ //portrait
            height = Qt.binding(function(){return 1/10 * Style.wHeight})
        } else { //landscape
            height = Qt.binding(function(){return 1/5 * Style.wHeight})
        }
    }

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            height = Qt.binding(function(){return 1/10 * Style.wHeight})
        } else { //landscape
            height = Qt.binding(function(){return 1/5 * Style.wHeight})
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

    }
}
