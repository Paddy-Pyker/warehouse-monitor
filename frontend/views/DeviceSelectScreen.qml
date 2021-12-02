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
            exit.anchors.bottomMargin = 50
        } else { //landscape
            exit.anchors.bottomMargin = 20
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



    //// main visuals section
    Custom.Header{
        id:header
        pheight: root.height
    }

    Custom.Subheader{
        id:subheader
        pheight: root.height
        toggleSubmenu: false


    }

}
