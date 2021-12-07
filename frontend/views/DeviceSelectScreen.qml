import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0
import components 1.0 as Custom

Item {

    id:root
    anchors.fill: parent
    focus: true

    Keys.onBackPressed: {
        exit.sourceComponent=closer
        exit.item.forceActiveFocus()
        exitTimer.start()
    }

    onHeightChanged: {
        if(root.height > root.width){ //portrait
            exit.anchors.bottomMargin = Qt.binding(function(){return 50})
            devices.anchors.leftMargin = Style.margin
            devices.anchors.rightMargin = Style.margin
            colorBar.theme="Custom2"

        } else { //landscape
            exit.anchors.bottomMargin = Qt.binding(function(){return 20})
            devices.anchors.leftMargin = Style.margin *7
            devices.anchors.rightMargin = Style.margin *7
            colorBar.theme="Custom"
        }
    }


    Loader{
        id:exit
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component{
        id:closer
        Text {
            text: qsTr("press again to exit")
            color: "darkgreen"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Style.tinyFontSize
            font.bold : true
            Keys.onBackPressed: Qt.quit()
            SequentialAnimation on opacity {  NumberAnimation {  to: 0; duration: 2000; }}
        }

    }

    Timer {
        id: exitTimer
        interval: 2000
        onTriggered: exit.setSource("")
    }



    //// view start here
    Custom.Header{
        id:header
    }

    Custom.DeleteHeader{
        id:deleteheader
        toggleSubmenu: false
        onCancelSelectDevice: {
            root.focus = true
            toggleSubmenu = false
            devices.model = controller.get_devices_from_database
            Style.limit_to_only_one_device_selection = false

        }
    }

    Custom.SettingsHeader{
        id:settingsheader
        toggleSubmenu: false
    }


    Custom.ModelTitleBar{
        id:modelTitleBar
        anchors.top: header.bottom
    }

    Custom.AddDeviceButton{
        id:addDeviceBtn
        z:5
    }


    ListView{
        id:devices
        anchors{
            top: modelTitleBar.bottom
            margins: Style.margin
            topMargin: 40
            left: parent.left
            right: parent.right
            bottom: parent.bottom

        }
        model : controller.get_devices_from_database
        clip: true
        delegate: Custom.DevicesDelegate{
            device: modelData
            onSelectedDevice: {
                //                    connectingDialog.source = "qrc:/components/ConnectingDialog.qml"
                //                    connectingDialog.item.description = id
                //                    bluetoothManager.device_selected(id,mac)
            }
            onPressedAndHeld: {
                deleteheader.toggleSubmenu = true
                deleteheader.focus = true
            }

        }


    }

}
