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
    property string _STATE

    state: _STATE
    signal selectedDevice(string serial_number,string last_reading_timestamp)
    signal pressedAndHeld(string serialnumber)




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



    MouseArea{
        anchors.fill: parent
        onPressed:{ _STATE = "pressed"; timer.start()}
        onCanceled: _STATE = ""
        pressAndHoldInterval: 350
        onPressAndHold: {console.log("held the button"); pressedAndHeld(device.serialNumber)}
    }

    Timer{
        id:timer
        interval: 350
        onTriggered: {_STATE=""; selectedDevice(serialnumber.text,devices.last_reading_timestamp);}
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
