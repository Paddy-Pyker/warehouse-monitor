import QtQuick 2.9
import assets 1.0

Item {
    id: root
    anchors.left: parent.left
    anchors.right: parent.right


    Text {
        anchors{
            top: parent.top
            topMargin: Style.margin
            left: parent.left
            right: parent.right
        }

        id: name
        text: qsTr("Devices")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Style.mediumFontSize
        color: "dimgray"

    }


    Rectangle{
        id:baseline
        anchors{
            top: name.bottom
            topMargin: Style.margin * .5
            left: parent.left
            right: parent.right
            leftMargin: Style.wWidth * 0.1
            rightMargin: Style.wWidth * 0.1
        }
        height: 1
        color: Style.colorAccent
    }

    height: name.height + baseline.height

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            name.anchors.topMargin = Qt.binding(function(){ return Style.margin})
            baseline.anchors.leftMargin = Qt.binding(function(){ return Style.wWidth * 0.1})
            baseline.anchors.rightMargin = Qt.binding(function(){ return Style.wWidth * 0.1})

        } else { //landscape
            name.anchors.topMargin = Qt.binding(function(){ return Style.margin * 2})
            baseline.anchors.topMargin = Qt.binding(function(){ return Style.margin})
            baseline.anchors.leftMargin = Qt.binding(function(){ return Style.wWidth * 0.2})
            baseline.anchors.rightMargin = Qt.binding(function(){ return Style.wWidth * 0.2})
        }
    }
}
