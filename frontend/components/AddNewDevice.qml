import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import assets 1.0

Item {
    id:root
    signal cancelPropagated()
    property string serialNumber
    property string device_name
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
                //                console.log("device already exist")
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

    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.8)
        z:1

        Rectangle{ //serial dialog
            id:serial_dialog
            anchors.centerIn: parent
            width: 0.8*parent.width
            height: 1/5 * parent.height
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
                font.pixelSize: Style.smallFontSize
                verticalAlignment: Qt.AlignVCenter

                inputMethodHints: Qt.ImhDigitsOnly


                Keys.onPressed: {
                    if ( event.key === Qt.Key_Enter  || event.key === Qt.Key_Return  )
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

                    busy.running = true
                    serialValue.readOnly = true
                    serialValue.color = "grey"
                    controller.check_for_device_availability(serialValue.text)
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
            width: 0.8*parent.width
            height: 1/5 * parent.height
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
            width: 0.8*parent.width
            height: 1/5 * parent.height
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
            width: 0.8*parent.width
            height: 1/5 * parent.height
            radius: 5
            visible: false

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
                    if ( event.key === Qt.Key_Enter  || event.key === Qt.Key_Return  )
                        namebtn.clicked()
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


                onClicked:{
                    console.log("device added successfully")
                    cancelPropagated()
                }
            }



        }

    }

}
