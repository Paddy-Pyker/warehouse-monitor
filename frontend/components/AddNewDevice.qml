import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import assets 1.0

Item {
    id:root
    signal cancelPropagated()
    property string serialNumber
    property alias autoFocus:serialValue
    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
        id:locker
        anchors.fill: parent
        z:0
    }

    Connections{
        target: controller
        function onDevice_availability_is_ready(responseCode){

            switch (responseCode){

            case 0:
                already_exist_dialog.visible = true
                break

            case 201:
                serialNumber = serialValue.text
                name_dialog.visible = true
                break

            default: serial_dialog_error.visible = true

            }
        }
    }

    Component.onCompleted: {
        if(Style.wHeight > Style.wWidth){ //portrait
            serial_dialog.height = Qt.binding(function(){return (1/5 * Style.wHeight) < 160 ? 160 : (1/5 * Style.wHeight) })
            serial_dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            serial_dialog.height = Qt.binding(function(){return (1/2.5 * Style.wHeight) < 137 ? 137 : (1/2.5 * Style.wHeight)})
            serial_dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }


    }

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            serial_dialog.height = Qt.binding(function(){return (1/5 * Style.wHeight) < 160 ? 160 : (1/5 * Style.wHeight) })
            serial_dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            serial_dialog.height = Qt.binding(function(){return (1/2.5 * Style.wHeight) < 137 ? 137 : (1/2.5 * Style.wHeight)})
            serial_dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }
    }


    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.55)
        z:1

        Rectangle{ //serial dialog
            id:serial_dialog
            anchors.centerIn: parent
            radius: 5

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                cached: true
                horizontalOffset: 5
                verticalOffset: 4
                radius: 10.0
                samples: 31
                color: "#80000000"
                smooth: true
            }

            TextField {
                id: serialValue
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                placeholderText: "Enter Serial Number"
                Material.accent: Style.colorAccent
                font.pixelSize: Style.smallTinyFontSize
                verticalAlignment: Qt.AlignVCenter

                inputMethodHints: Qt.ImhDigitsOnly


                Keys.onPressed: {
                    if ( (event.key === Qt.Key_Enter  || event.key === Qt.Key_Return  ) && serialValue.text)
                        btn.clicked()
                }


            }


            Button{
                id:btn
                anchors{
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: Style.margin
                }
                highlighted: true

                Material.accent: Style.colorAccent

                text: "OK"
                font.bold: true

                visible: !busy.running

                onClicked:{
                    if(serialValue.text){
                        busy.running = true
                        serialValue.readOnly = true
                        serialValue.color = "grey"
                        controller.check_for_device_availability(serialValue.text)
                    }
                }
            }

            BusyIndicator{
                id:busy
                running: false
                Material.accent: "#7CC4AC"
                anchors{
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: Style.margin *.6
                }

            }


        }


        Rectangle{  //error dialog
            id:serial_dialog_error
            anchors.centerIn: parent
            width: serial_dialog.width
            height: serial_dialog.height
            radius: 5
            visible: false

            Text{
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                text: "Device Authentication Failed"
                horizontalAlignment: Text.AlignHCenter
                Material.accent: Style.colorAccent
                font.bold: true
                font.pixelSize: Style.smallFontSize
                color: "dimgrey"

            }


            Button{
                id:errorbtn
                anchors{
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: Style.margin
                }
                highlighted: true

                Material.accent: "#EF9A9A"

                text: "OK"
                font.bold: true


                onClicked:{
                    cancelPropagated()
                }
            }


        }

        Rectangle{  //already exist dialog
            id:already_exist_dialog
            anchors.centerIn: parent
            width: serial_dialog.width
            height: serial_dialog.height
            radius: 5
            visible: false

            Text{
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                text: "Device Already Exist"
                horizontalAlignment: Text.AlignHCenter
                Material.accent: Style.colorAccent
                font.bold: true
                font.pixelSize:Style.smallFontSize
                color: "dimgrey"

            }


            Button{
                id:alreadyexistbtn
                anchors{
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: Style.margin
                }
                highlighted: true

                Material.accent: Style.colorAccent

                text: "OK"
                font.bold: true


                onClicked:{
                    cancelPropagated()
                }
            }


        }

        Rectangle{ //name dialog
            id:name_dialog
            anchors.centerIn: parent
            width: serial_dialog.width
            height: serial_dialog.height
            radius: 5
            visible: false

            onVisibleChanged: if(visible) nameValue.forceActiveFocus()

            TextField {
                id: nameValue
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                placeholderText: "Enter a name for the device"
                Material.accent: Style.colorAccent
                font.pixelSize: Style.smallTinyFontSize
                verticalAlignment: Qt.AlignVCenter


                Keys.onPressed: {
                    if ( (event.key === Qt.Key_Enter  || event.key === Qt.Key_Return))
                        conf.start()
                }


            }


            Button{
                id:namebtn
                anchors{
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: Style.margin
                }
                highlighted: true

                Material.accent: Style.colorAccent

                text: "OK"
                font.bold: true


                onClicked:conf.start()
            }



        }

        Timer{
            id:conf
            interval: 200
            onTriggered: {
                if(nameValue.text){
                    controller.addNewDevice(nameValue.text,serialNumber)
                    controller.modelChanged()
                    cancelPropagated()
                }
            }
        }

    }

}
