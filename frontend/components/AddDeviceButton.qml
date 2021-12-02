import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0


Item {

    signal addNewDeviceClick()
    id:root
    anchors.fill: parent

    RoundButton{
        id:btn
        anchors{
            bottom: parent.bottom
            bottomMargin: 70
            right: parent.right
            rightMargin: Style.margin
        }
        flat: true
        highlighted: true
        Material.accent: "white"
        Material.background: Style.colorReal
        Material.elevation: 6
        font.pixelSize: Style.hugeFontSize
        text: "\uf067"
        font.family: Style.fontAwesome
        height: 70
        width: 70
        onClicked: addNewDeviceClick()

    }

    onHeightChanged: {
        if(root.height > root.width){
            btn.anchors.bottomMargin = Qt.binding(function() {return 70})
        } else {
              btn.anchors.bottomMargin = Qt.binding(function() {return 20})
        }
    }



}
