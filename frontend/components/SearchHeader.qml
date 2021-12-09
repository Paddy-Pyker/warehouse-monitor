import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {
    signal cancelSelectDevice()
    property bool toggleSubmenu: false
    property alias autoFocus: textfield

    id:root

    Keys.onBackPressed: {
        textfield.clear()
        cancelSelectDevice()
    }
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

        Button{
            id:deletebutton
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
            onClicked: {textfield.clear();cancelSelectDevice()}

        }

        TextField{
            id:textfield
            anchors{
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            width: 1/1.5 * parent.width
            placeholderText: "input name or serial number"
            placeholderTextColor: "grey"
            color: "white"
            Material.accent: Style.colorAccent
            background: null
            onContentSizeChanged: {
                Qt.inputMethod.reset()
                if(!textfield.text){
                    controller.modelChanged()
                } else controller.searchDevice(textfield.text)


            }

        }


    }

}
