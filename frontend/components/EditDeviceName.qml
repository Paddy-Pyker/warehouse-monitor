import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import assets 1.0

Item {

    id:root
    anchors.fill: parent

    signal cancelPropagated()
    signal comfirmEdit(string newName)

    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
        id:locker
        anchors.fill: parent
        z:0
    }

    Component.onCompleted: {
        if(Style.wHeight > Style.wWidth){ //portrait
            dialog.height = Qt.binding(function(){return (1/5 * Style.wHeight) < 160 ? 160 : (1/5 * Style.wHeight) })
            dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            dialog.height = Qt.binding(function(){return (1/2.5 * Style.wHeight) < 137 ? 137 : (1/2.5 * Style.wHeight)})
            dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }


    }

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            dialog.height = Qt.binding(function(){return (1/5 * Style.wHeight) < 160 ? 160 : (1/5 * Style.wHeight) })
            dialog.width = Qt.binding(function(){return (0.8* Style.wWidth)})
        } else { //landscape
            dialog.height = Qt.binding(function(){return (1/2.5 * Style.wHeight) < 137 ? 137 : (1/2.5 * Style.wHeight)})
            dialog.width = Qt.binding(function(){return (0.4 * Style.wWidth)})
        }
    }


    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.55)
        z:1

        Rectangle{ //serial dialog
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

            TextField {
                id: nameValue
                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Style.margin*2
                }

                placeholderText: Style.selectedName
                Material.accent: Style.colorAccent
                font.pixelSize: Style.smallTinyFontSize
                verticalAlignment: Qt.AlignVCenter

                Keys.onPressed: {
                    if ( (event.key === Qt.Key_Enter  || event.key === Qt.Key_Return) && nameValue.text  )
                        editbtn.clicked()
                }


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
                id:editbtn
                anchors{
                    bottom: parent.bottom
                    right: parent.right
                    margins: Style.margin *0.5
                    rightMargin: Style.margin*2
                }

                flat:true
                highlighted: true

                Material.accent: "#EF9A9A"

                text: "RENAME"
                font.bold: true


                onClicked:{
                    if(nameValue.text)
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
        onTriggered: comfirmEdit(nameValue.text)
    }
}



