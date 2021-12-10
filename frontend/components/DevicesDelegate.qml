import QtQuick 2.9
import assets 1.0
import Device 1.0


Rectangle {
    id:root
    anchors{
        left: parent.left
        right: parent.right

    }

    height: 60

    opacity: .75
    radius: 10

    property Device device

    signal selectedDevice(string name,string serial_number,string last_reading_timestamp)
    signal pressedAndHeld(string name,string serialnumber)




    Text {
        id:name
        text: device.name
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: Style.margin
        }
        width: 1/2* parent.width
        font.pixelSize:Style.smallTinyFontSize
        elide: Text.ElideRight
    }


    Text {
        id:serialnumber
        text: device.serialNumber

        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignRight
        anchors{
            bottom: parent.bottom
            right: parent.right
            left: name.right
            margins: Style.margin
        }
        height: parent.height
        font.pixelSize: Style.tinyFontSize
        elide: Text.ElideRight
    }


    property bool fix_state_on_hold

    MouseArea{
        anchors.fill: parent
        onPressed:{
            root.state = "pressed";
            timer.start()
        }
        onCanceled: root.state = ""
        pressAndHoldInterval: 320
        onPressAndHold: {
            if(!Style.limit_to_only_one_device_selection){
                fix_state_on_hold  = true
                pressedAndHeld(device.name,device.serialNumber)
                root.state = "pressed"
                Style.limit_to_only_one_device_selection = true
            }
        }
    }

    Timer{
        id:timer
        interval: 350
        onTriggered: {
            if(!fix_state_on_hold){
                root.state="";
                selectedDevice(name.text,serialnumber.text,devices.last_reading_timestamp)
            }
        }
    }



    states: [
        State {
            name: "pressed"
            PropertyChanges {
                target: root
                color: "lightgrey"

            }
        }]

}
