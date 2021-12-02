import QtQuick 2.9
import QtQuick.Controls 2.5
import assets 1.0

ApplicationWindow {

    id: wroot
    visible: true
    title: qsTr("Warehouse Monitor")
    width: 720 * .7
    height: 1240 * .7
    color: "white"



    Component.onCompleted: {
        colorBar.theme="Light"
        colorBar.statusBarColor=Qt.rgba(0,0,0,0)
        colorBar.navigationBarColor=Qt.rgba(0,0,0,0)
        Style.wWidth = Qt.binding(function() {return width})
        Style.wHeight = Qt.binding(function() {return height})
    }

    Loader {
        id: splashLoader
        anchors.fill: parent
        source: "SplashScreen.qml"
        asynchronous: true
        visible: true


        onStatusChanged: {
            if (status === Loader.Ready) {
                appLoader.setSource("DeviceSelectScreen.qml");

            }
        }
    }

    Connections {
        target: splashLoader.item
        onReadyToGo: {
            appLoader.visible = true
            splashLoader.visible = false
            splashLoader.setSource("")
            colorBar.theme="Dark"
            appLoader.item.forceActiveFocus();
        }
    }

    Loader {
        id: appLoader
        anchors.fill: parent
        visible: false
        asynchronous: true
        onStatusChanged: {
            if (status === Loader.Ready)
                splashLoader.item.appReady()

        }
    }
}
