import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0

Item {
    id: root
    anchors.fill: parent

    property bool appIsReady: false
    property bool splashIsReady: false

    property bool ready: appIsReady && splashIsReady
    onReadyChanged: if (ready) readyToGo();

    signal readyToGo()

    function appReady()
    {
        appIsReady = true
    }


    Rectangle{
        id:rec
        anchors.fill: parent
        color: "white"


        Image {
            id: splashimage
            anchors{
                margins: Style.margin
                top: parent.top
                topMargin: Style.margin*5
            }
            source: "qrc:/assets/splashImage.png"
            height: Style.heightForWidth(width,sourceSize)


        }

                Text{
                    id:label
                    anchors{
                        margins: Style.margin
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: "Warehouse  Monitor"
                    font.pixelSize: Style.largeFontSize
                    font.family: Style.corsiva
                    font.bold: true
                    color: "#008A5F"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                }

                BusyIndicator{
                    id:busy
                    running: true
                    Material.accent: "#7CC4AC"
                    anchors{
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: parent.height*0.1
                        horizontalCenter: parent.horizontalCenter

                    }

                }
    }

    Timer {
        id: splashTimer
        interval: 2345
        onTriggered: splashIsReady = true
    }

    onHeightChanged: {
        if(Style.wHeight > Style.wWidth){ //portrait
            splashimage.anchors.left = rec.left
            splashimage.anchors.right = rec.right
            splashimage.height = Style.heightForWidth(splashimage.width,splashimage.sourceSize)

            label.anchors.verticalCenterOffset = 0
            busy.anchors.verticalCenterOffset = 0.1 *root.height


        } else { //landscape
            splashimage.anchors.left = undefined
            splashimage.anchors.right = undefined
            splashimage.width = 1/2 * root.width
            splashimage.anchors.horizontalCenter = rec.horizontalCenter
            splashimage.height = Style.heightForWidth(splashimage.width,splashimage.sourceSize)

            label.anchors.verticalCenterOffset = 0.2 *root.height
            busy.anchors.verticalCenterOffset = 0.35 *root.height

        }
    }

    Component.onCompleted: {
        splashTimer.start()
    }
}

