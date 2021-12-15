import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0
import QtQuick.Window 2.2
import assets 1.0

Item {
    id:root
    anchors.fill: parent
    signal cancelPropagated()

    Keys.onBackPressed: {
        cancelPropagated()
    }

    MouseArea{
        anchors.fill: parent
    }

    Rectangle{
        id:header
        anchors{
            left: parent.left
            right: parent.right
        }
        z:100

        color: Style.colorReal

        Button{
            id:sett
            anchors{
                bottom: parent.bottom
                left: parent.left
            }
            flat: true
            highlighted: true
            Material.accent: "white"
            font.pixelSize: Style.smallFontSize
            text: "\uf060"
            font.family: Style.fontAwesomeLight
            onClicked: cancelPropagated()


        }

        Text {
            id: name
            anchors{
                bottom: parent.bottom
                verticalCenter: sett.verticalCenter
                left: sett.right
            }

            color: "white"
            text: qsTr("Options")
            font.pixelSize: Style.smallTinyFontSize
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

        }

        Component.onCompleted: {
            if(Style.wHeight > Style.wWidth){ //portrait
                height = Qt.binding(function(){return (1/9 * Style.wHeight) < 80 ? 80 : (1/9 * Style.wHeight) })
            } else { //landscape
                height = Qt.binding(function(){return (1/5 * Style.wHeight) < 65 ? 65 : (1/5 * Style.wHeight)})
            }
        }

        onHeightChanged: {
            if(Style.wHeight > Style.wWidth){ //portrait
                height = Qt.binding(function(){return (1/9 * Style.wHeight) < 80 ? 80 : (1/9 * Style.wHeight) })
            } else { //landscape
                height = Qt.binding(function(){return (1/5 * Style.wHeight) < 65 ? 65 : (1/5 * Style.wHeight)})
            }
        }
    }

    Rectangle{
        id:content
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Flickable{
            anchors.fill: parent
            contentHeight: Screen.primaryOrientation == Qt.PortraitOrientation? Screen.desktopAvailableHeight*1.15 : Screen.desktopAvailableHeight*2.15

            Rectangle {
                id: mainForm
                anchors.fill: parent
                height: cellSize * 12
                width: cellSize * 8
                property double mm: Screen.pixelDensity
                property double cellSize: mm * 7
                property int fontSizePx: cellSize * 0.32
                property var date: new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay);
                clip: true
                signal ok
                signal cancel


                Rectangle {
                    id: titleOfDate
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    height: 2.5 * mainForm.cellSize
                    width: parent.width

                    z: 2
                    Rectangle {
                        id: selectedYear
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                        height: mainForm.cellSize * 1
                        color: parent.color
                        Text {
                            id: yearTitle
                            anchors{
                                top: parent.top
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }

                            topPadding: mainForm.cellSize * 0.5
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: mainForm.fontSizePx * 1.7
                            color: yearsList.visible ? Style.colorReal :Style.colorAccent
                            text: calendar.currentYear
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                yearsList.show();
                            }
                        }
                    }
                    Text {
                        id: selectedWeekDayMonth
                        anchors{
                            top: selectedYear.bottom
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }

                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: height * 0.5
                        text: calendar.weekNames[calendar.week].slice(0, 3) + ", " + calendar.currentDay + " " + calendar.months[calendar.currentMonth].slice(0, 3)
                        color: yearsList.visible ? Style.colorAccent :Style.colorReal
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                yearsList.hide();
                            }
                        }
                    }
                }

                ListView {
                    id: calendar
                    anchors {
                        top: titleOfDate.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: mainForm.cellSize * 0.5
                        rightMargin: mainForm.cellSize * 0.5
                    }
                    height: mainForm.cellSize * 7
                    visible: true
                    z: 1

                    snapMode: ListView.SnapToItem
                    orientation: ListView.Horizontal
                    spacing: mainForm.cellSize
                    model: CalendarModel {
                        id: calendarModel
                        from: new Date(Style.selectedDate? new Date(Style.selectedDate).getFullYear():new Date().getFullYear(), 0, 1);
                        to: new Date(new Date().getFullYear(), 11, 31);
                        function  setYear(newYear) {
                            if (calendarModel.from.getFullYear() > newYear) {
                                calendarModel.from = new Date(newYear, 0, 1);
                                calendarModel.to = new Date(newYear, 11, 31);
                            } else {
                                calendarModel.to = new Date(newYear, 11, 31);
                                calendarModel.from = new Date(newYear, 0, 1);
                            }
                            calendar.currentYear = newYear;
                            calendar.goToLastPickedDate();
                            mainForm.setCurrentDate();
                        }
                    }

                    property date adjustedDate: Style.selectedDate? new Date(Style.selectedDate) : new Date()
                    property int currentDay: adjustedDate.getDate()
                    property int currentMonth: adjustedDate.getMonth()
                    property int currentYear: adjustedDate.getFullYear()
                    property int week: adjustedDate.getDay()
                    property var months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                    property var weekNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

                    delegate: Rectangle {
                        height: mainForm.cellSize * 8.5 //6 - на строки, 1 на дни недели и 1.5 на подпись
                        width: mainForm.cellSize * 8
                        Rectangle {
                            id: monthYearTitle
                            anchors {
                                top: parent.top
                            }
                            height: mainForm.cellSize * 1.3
                            width: parent.width

                            Text {
                                anchors.centerIn: parent
                                font.pixelSize: mainForm.fontSizePx * 1.2
                                text: calendar.months[model.month] + " " + model.year;
                            }
                        }

                        DayOfWeekRow {
                            id: weekTitles
                            Layout.column: 1
                            locale: monthGrid.locale
                            anchors {
                                top: monthYearTitle.bottom
                            }
                            height: mainForm.cellSize
                            width: parent.width
                            delegate: Text {
                                text: model.shortName
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: mainForm.fontSizePx
                            }
                        }

                        MonthGrid {
                            id: monthGrid
                            month: model.month
                            year: model.year
                            spacing: 0
                            anchors {
                                top: weekTitles.bottom
                            }
                            width: mainForm.cellSize * 8
                            height: mainForm.cellSize * 6

                            locale: Qt.locale("en_US")
                            delegate: Rectangle {
                                height: mainForm.cellSize
                                width: mainForm.cellSize
                                radius: height * 0.5
                                property bool highlighted: enabled && model.day == calendar.currentDay && model.month == calendar.currentMonth

                                enabled: model.month === monthGrid.month
                                color: enabled && highlighted ? Style.colorAccent : "white"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.day
                                    font.pixelSize: mainForm.fontSizePx
                                    scale: highlighted ? 1.25 : 1
                                    Behavior on scale { NumberAnimation { duration: 150 } }
                                    visible: parent.enabled
                                    color: parent.highlighted ? "white" : "black"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        calendar.currentDay = model.date.getDate();
                                        calendar.currentMonth = model.date.getMonth();
                                        calendar.week = model.date.getDay();
                                        calendar.currentYear = model.date.getFullYear();
                                        mainForm.setCurrentDate();
                                    }
                                }
                            }
                        }
                    }


                    Component.onCompleted: goToLastPickedDate()
                    function goToLastPickedDate() {
                        positionViewAtIndex(calendar.currentMonth, ListView.SnapToItem)
                    }
                }

                ListView {
                    id: yearsList
                    anchors.fill: calendar
                    orientation: ListView.Vertical
                    visible: false
                    z: calendar.z

                    property int currentYear
                    property int startYear: 2010
                    property int endYear : new Date().getFullYear();
                    model: ListModel {
                        id: yearsModel
                    }

                    delegate: Rectangle {
                        width: parent.width
                        height: mainForm.cellSize * 1.5
                        Text {
                            anchors.centerIn: parent
                            font.pixelSize: mainForm.fontSizePx * 1.5
                            text: name
                            scale: index == yearsList.currentYear - yearsList.startYear ? 1.5 : 1
                            color: Qt.rgba(0,0,0,0.6)
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                calendarModel.setYear(yearsList.startYear + index);
                                yearsList.hide();
                            }
                        }
                    }

                    Component.onCompleted: {
                        for (var year = startYear; year <= endYear; year ++)
                            yearsModel.append({name: year});
                    }
                    function show() {
                        visible = true;
                        calendar.visible = false
                        currentYear = calendar.currentYear
                        yearsList.positionViewAtIndex(currentYear - startYear, ListView.SnapToItem);
                    }
                    function hide() {
                        visible = false;
                        calendar.visible = true;
                    }
                }


                ComboBox{
                    id:combo
                    anchors{
                        top: calendar.bottom
                        topMargin: mainForm.height*.1
                        horizontalCenter: parent.horizontalCenter
                    }
                    model: ["Daily", "Weekly", "Monthly", "Annually"]
                    currentIndex: model.indexOf(Style.selectedOption?Style.selectedOption:"")
                    Material.accent: Style.colorAccent




                }


                Button{
                    id:btn
                    anchors{
                        top: combo.bottom
                        horizontalCenter: parent.horizontalCenter
                        margins: Style.margin
                        topMargin: Style.margin*4
                    }
                    highlighted: true

                    Material.accent: Style.colorReal

                    text: "OK"
                    font.bold: true
                    onClicked: {
                        Style.selectedDate = mainForm.date.getTime()
                        Style.selectedOption = combo.currentValue
                        controller.set_selectedOptions(Style.selectedOption,Style.selectedDate.toString())
                        cancelPropagated()

                    }
                }

                function setCurrentDate() {
                    mainForm.date = new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay);
                }
            }
        }





    }


}


