import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import assets 1.0


Item {
    id:root
    anchors.fill: parent

    signal cancelPropagated()
    signal goBackToMainMenu()

    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
        id:locker
        anchors.fill: parent
        onClicked: cancelPropagated()
    }


    Component.onCompleted: {
        if(Style.wHeight > Style.wWidth){ //portrait
            dialog.height = Qt.binding(function(){return (1/7 * Style.wHeight) < 160 ? 160 : (1/7 * Style.wHeight) })
            dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            dialog.height = Qt.binding(function(){return (1/4 * Style.wHeight) < 137 ? 137 : (1/4 * Style.wHeight)})
            dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }
    }

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            dialog.height = Qt.binding(function(){return (1/7 * Style.wHeight) < 160 ? 160 : (1/7 * Style.wHeight) })
            dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            dialog.height = Qt.binding(function(){return (1/4 * Style.wHeight) < 137 ? 137 : (1/4 * Style.wHeight)})
            dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }
    }



    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.55)

        Rectangle{
            id:dialog
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

            MouseArea{
                anchors.fill: parent
            }


            Text{
                id:title
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                text: "Exit to Main Menu?"
                horizontalAlignment: Text.AlignHCenter
                Material.accent: Style.colorAccent
                font.bold: true
                font.pixelSize: Style.smallFontSize
                color: "dimgrey"

            }


            Button{
                id:cancelbuttn
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    margins: Style.margin *0.5
                    leftMargin: Style.margin*2
                }
                flat: true
                highlighted: true

                Material.accent: Style.colorAccent

                text: "CANCEL"
                font.bold: true


                onClicked:{
                    exit.start()
                }
            }

            Button{
                id:deletebtn
                anchors{
                    bottom: parent.bottom
                    right: parent.right
                    margins: Style.margin *0.5
                    rightMargin: Style.margin*2
                }

                flat:true
                highlighted: true

                Material.accent: "#EF9A9A"

                text: "EXIT"
                font.bold: true


                onClicked:{
                    conf.start()
                }
            }

        }
    }

    Timer{
        id:exit
        interval: 200
        onTriggered: cancelPropagated()
    }

    Timer{
        id:conf
        interval: 200
        onTriggered: goBackToMainMenu()
    }


}
