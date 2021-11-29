import QtQuick 2.9
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
        anchors.fill: parent
        color: "lightblue"

        Image {
            id: splashimage
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -150
            anchors{
                left: parent.left
                right: parent.right
                margins: Style.margin
            }
            source: ""
            height: Style.heightForWidth(width,sourceSize)

        }

                Text{
                    anchors{
                        top: splashimage.bottom
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: Style.margin
                        topMargin: -Style.margin*12
                    }

                    text: "Hello world"
                    font.pixelSize: Style.largeFontSize
                    font.bold: true
                    color: "#fff"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                }
    }

    Timer {
        id: splashTimer
        interval: 2000
        onTriggered: splashIsReady = true
    }

    Component.onCompleted: {
        splashTimer.start()
    }
}

