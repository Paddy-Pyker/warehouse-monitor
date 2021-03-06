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
            exit.anchors.bottomMargin = Qt.binding(function(){return 50})
            devices.anchors.leftMargin = Style.margin
            devices.anchors.rightMargin = Style.margin
            colorBar.theme="Custom2"

        } else { //landscape
            exit.anchors.bottomMargin = Qt.binding(function(){return 20})
            devices.anchors.leftMargin = Style.margin *7
            devices.anchors.rightMargin = Style.margin *7
            colorBar.theme="Custom"
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
            id:tx
            text: qsTr("Touch again to exit")
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



    //// view start here
    Custom.Header{
        id:header
        onAddNewDevice: {

            addNewDevice.setSource("qrc:/components/AddNewDevice.qml")
            addNewDevice.item.autoFocus.forceActiveFocus()
        }

        onSearchButtonClicked: {
            searchHeader.toggleSubmenu = true
            header.toggleSubmenu = false
            searchHeader.autoFocus.forceActiveFocus()
        }
    }


    Custom.SearchHeader{
        id:searchHeader
        toggleSubmenu: false

        onCancelSelectDevice: {
            root.focus = true
            toggleSubmenu= false
            header.toggleSubmenu = true
            devices.model = controller.get_devices_from_database
        }
    }

    Custom.DeleteHeader{
        id:deleteheader
        toggleSubmenu: false
        onCancelSelectDevice: {
            root.focus = true
            toggleSubmenu = false
            devices.model = controller.get_devices_from_database
            Style.limit_to_only_one_device_selection = false

        }

        onDeleteButtonClicked:{
            deleteDeviceDialog.setSource("qrc:/components/DeleteDeviceDialog.qml")
            deleteDeviceDialog.item.forceActiveFocus()
        }

        onEditButtonClicked: {
            editDeviceName.setSource("qrc:/components/EditDeviceName.qml");
            editDeviceName.item.forceActiveFocus()
        }
    }

    Custom.SettingsHeader{
        id:settingsheader
        toggleSubmenu: false

        onSettingsButtonClicked: {
            settingsPage.setSource("qrc:/components/SettingsPage.qml")
            settingsPage.item.forceActiveFocus()
        }
        onTableButtonClicked:  console.log("table button clicked")
    }


    Custom.ModelTitleBar{
        id:modelTitleBar
        anchors.top: header.bottom
    }

    Custom.AddDeviceButton{
        id:addDeviceBtn
        visible: !(deleteheader.visible || searchHeader.visible)
        z:5
        onAddNewDeviceClick: {

            addNewDevice.setSource("qrc:/components/AddNewDevice.qml")
            addNewDevice.item.autoFocus.forceActiveFocus()
        }

    }

    Connections{
        target: controller
        function onModelChanged(){
            devices.model = controller.get_devices_from_database
        }

        function onModelChanged_SearchResult(result){
            devices.model = result
        }

    }

    ListView{
        id:devices
        anchors{
            top: modelTitleBar.bottom
            margins: Style.margin
            topMargin: 40
            left: parent.left
            right: parent.right
            bottom: parent.bottom

        }
        model : controller.get_devices_from_database
        clip: true
        delegate: Custom.DevicesDelegate{
            device: modelData
            onSelectedDevice: {
                Style.selectedSerialNumber = serial_number
                Style.lastReadingTimestamp = last_reading_timestamp
                settingsheader.toggleSubmenu = true
                settingsheader.customName = name
                header.disableEdit = false
                header.disableMenu = false
                graphLoader.setSource("qrc:/components/GraphDisplay.qml")
                graphLoader.item.forceActiveFocus()

            }
            onPressedAndHeld: {
                deleteheader.toggleSubmenu = true
                deleteheader.focus = true
                Style.selectedSerialNumber = serialnumber
                Style.selectedName = name
            }

        }


    }

    Loader{
        id:addNewDevice
        anchors.fill: parent
        z:6
    }

    Connections{
        target: addNewDevice.item
        function onCancelPropagated(){
            addNewDevice.setSource("")
        }
    }

    Loader{
        id:deleteDeviceDialog
        anchors.fill: parent
        z:6
    }

    Connections{
        target: deleteDeviceDialog.item

        function onCancelPropagated(){
            controller.modelChanged()
            deleteheader.toggleSubmenu = false
            Style.limit_to_only_one_device_selection = false
            deleteDeviceDialog.setSource("")
        }

        function onComfirmDelete(){
            controller.deleteDevice(Style.selectedSerialNumber)
            controller.modelChanged()
            deleteheader.toggleSubmenu = false
            Style.limit_to_only_one_device_selection = false
            deleteDeviceDialog.setSource("")
        }
    }

    Loader{
        id:editDeviceName
        anchors.fill: parent
        z:6
    }

    Connections{
        target: editDeviceName.item

        function onCancelPropagated(){
            controller.modelChanged()
            deleteheader.toggleSubmenu = false
            Style.limit_to_only_one_device_selection = false
            editDeviceName.setSource("")
        }

        function onComfirmEdit(newName){
            controller.renameDevice(Style.selectedSerialNumber,newName)
            controller.modelChanged()
            deleteheader.toggleSubmenu = false
            Style.limit_to_only_one_device_selection = false
            editDeviceName.setSource("")
        }
    }

    Loader{
        id:graphLoader
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom

        }
        z:7
    }

    Connections{
        target: graphLoader.item
        function onCancelPropagated(){
            graphExitDialog.setSource("qrc:/components/GraphEditDialog.qml")
            graphExitDialog.item.forceActiveFocus()
        }
    }

    Loader{
        id:graphExitDialog
        anchors.fill: parent
        z:8
    }

    Connections{
        target: graphExitDialog.item
        function onCancelPropagated(){
            graphExitDialog.setSource("")
            graphLoader.item.forceActiveFocus()
        }

        function onGoBackToMainMenu(){
            graphExitDialog.setSource("")
            graphLoader.setSource("")
            settingsheader.toggleSubmenu = false
            header.disableEdit = true
            header.disableMenu = true
            deleteheader.toggleSubmenu = false
            controller.modelChanged()
            Style.selectedDate=0
            Style.selectedOption=""
            controller.set_selectedOptions("","")
        }
    }


    Loader{
        id:settingsPage
        anchors.fill: parent
        z:100
    }

    Connections{
        target: settingsPage.item
        function onCancelPropagated(){
            settingsPage.setSource("")
            graphLoader.item.forceActiveFocus()
        }
    }


}
