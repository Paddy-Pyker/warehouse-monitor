import QtQuick 2.9
import QtCharts 2.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import assets 1.0
import Readings 1.0


Item {

    id:root
    anchors.fill: parent
    signal cancelPropagated()

    property list<Readings> readings
    property date minDate
    property date maxDate

    property string serialNumber: Style.selectedSerialNumber
    property string lastReadingTimestamp: Style.lastReadingTimestamp === "" ? "0" : Style.lastReadingTimestamp

    Keys.onBackPressed: {
        cancelPropagated()
    }


    Component.onCompleted: {
        controller.fetch_http_data(serialNumber,lastReadingTimestamp)

    }

    Connections{
        target: controller

        function onLoad_from_db_rebounced(){
            readings = controller.load_readings_from_database
            console.log(readings.length)

            if(readings.length){
                minDate = new Date(parseInt(readings[0].timestamp))
                maxDate = new Date(parseInt(readings[readings.length-1].timestamp))
            } else {
                minDate = new Date((new Date()).getTime() - 86400000)
                maxDate = new Date()
            }

            temperature_line.clear()
            temperature_line_scatter.clear()
            humidity_line.clear()
            humidity_line_scatter.clear()
            temperature_spline.clear()
            temperature_spline_scatter.clear()
            humidity_spline.clear()
            humidity_spline_scatter.clear()

            for(let i = 0; i < readings.length; i++){
                temperature_line.append(readings[i].timestamp,readings[i].temperature)
                temperature_line_scatter.append(readings[i].timestamp,readings[i].temperature)
                humidity_line.append(readings[i].timestamp,readings[i].humidity)
                humidity_line_scatter.append(readings[i].timestamp,readings[i].humidity)
                temperature_spline.append(readings[i].timestamp,readings[i].temperature)
                temperature_spline_scatter.append(readings[i].timestamp,readings[i].temperature)
                humidity_spline.append(readings[i].timestamp,readings[i].humidity)
                humidity_spline_scatter.append(readings[i].timestamp,readings[i].humidity)
            }

            graphFlick.visible = true



        }
    }

    Rectangle{
        id:background
        anchors.fill:parent
        color: "white"

        MouseArea{
            anchors.fill: parent
        }

        BusyIndicator{
            id:b_indicator
            anchors.centerIn:parent
            Material.accent: Style.colorAccent
            implicitWidth: 80
            implicitHeight:80
            running: !graphFlick.visible
        }

        Flickable{
            property int chartHeight: 350
            id:graphFlick
            anchors.fill: parent
            contentHeight: chart0_1.height+chart0_2.height+chart.height
            clip: true
            visible: false


            function toMsecsSinceEpoch(date) {
                var msecs = date.getTime();
                return msecs;
            }

            Text {
                id: txt
                text: ""
                color: "red"
                z:2
            }



            Timer{
                id:disable_text
                interval: 2000
                onTriggered: {
                    txt.text=""
                    txt2.text=""
                    txt3.text=""
                }
            }

            DateTimeAxis {
                id:datetime
                format: "h:mm ap (dd.MM.yy)"
                tickCount: 5
                labelsAngle: -35
                min: minDate
                max: maxDate
            }

            DateTimeAxis {
                id:datetime2
                format: "h:mm ap (dd.MM.yy)"
                tickCount: 5
                labelsAngle: -35
                min: minDate
                max: maxDate
            }

            DateTimeAxis {
                id:datetime3
                format: "h:mm ap (dd.MM.yy)"
                tickCount: 5
                labelsAngle: -35
                min: minDate
                max: maxDate
            }

            ValueAxis {
                id:temperatureAxis
                min: 20;
                max: 32;
                labelFormat: "%d&deg;C"
            }

            ValueAxis{
                id:humidityAxis
                min: 20;
                max: 80;
                labelFormat: "%d%"
            }

            ValueAxis {
                id:temperatureAxis2
                min: 20;
                max: 32;
                labelFormat: "%d&deg;C"
                //labelsColor:temperature_spline.color
            }

            ValueAxis{
                id:humidityAxis2
                min: 20;
                max: 80;
                labelFormat: "%d%"
                //labelsColor:humidity_spline.color
            }


            ChartView{
                id:chart0_1
                x: -30
                width: parent.width + 80
                height: graphFlick.chartHeight
                title: "Temperature"
                titleFont.bold: true
                legend.visible: false
                antialiasing: true


                LineSeries {
                    id:temperature_line
                    name: "Temperature"
                    axisX: datetime
                    axisY: temperatureAxis
                    color: "dodgerblue"
                    width: 2

     // with the onclick present at the LineSeries and removed from the ScatterSeries,
     // and at the same time their positions are switched,
     // the end user can get the y-values at any particular point on the graph

                }


                ScatterSeries{
                    id:temperature_line_scatter
                    markerSize: 8
                    color: temperature_line.color
                    borderWidth: 2
                    borderColor: "white"

                    onClicked:  {
                        txt.x = chart0_1.mapToPosition(point, temperature_line_scatter).x
                        txt.y = chart0_1.mapToPosition(point, temperature_line_scatter).y
                        txt.text = parseFloat(point.y).toFixed(2) + "\xB0 C";
                        disable_text.stop()
                        disable_text.start()
                    }

                    axisX: datetime
                    axisY: temperatureAxis


                }






            }

            ChartView{
                id:chart0_2
                x: -30
                width: parent.width + 80
                height: graphFlick.chartHeight
                anchors.top: chart0_1.bottom
                legend.visible: false
                title: "Relative Humidity"
                titleFont.bold: true
                antialiasing: true



                Text {
                    id: txt2
                    text: ""
                    color: "blue"
                    z:2
                }

                LineSeries {
                    id:humidity_line
                    name: "Relative Humidity"
                    axisX: datetime2
                    axisY:humidityAxis
                    color: "deepPink"
                    width: 2
                }


                ScatterSeries{
                    id:humidity_line_scatter
                    markerSize: 8
                    color: humidity_line.color
                    borderWidth: 2
                    borderColor: "white"

                    onClicked: {
                        txt2.x = chart0_2.mapToPosition(point, humidity_line_scatter).x
                        txt2.y = chart0_2.mapToPosition(point, humidity_line_scatter).y
                        txt2.text = parseFloat(point.y).toFixed(2) +"%";
                        disable_text.stop()
                        disable_text.start()
                    }

                    axisX: datetime2
                    axisY:humidityAxis
                }





            }


            ChartView {
                id: chart
                x: -30
                width: parent.width + 80
                height: graphFlick.chartHeight
                anchors.top: chart0_2.bottom
                legend.alignment: Qt.AlignTop
                antialiasing: true

                Text {
                    id: txt3
                    text: ""
                    color: "lime"
                }

                LineSeries {
                    id:temperature_spline
                    name: "Temperature"
                    axisX: datetime3
                    axisY: temperatureAxis2
                    color: "dodgerblue"
                    width: 2
                }

                ScatterSeries{
                    id:temperature_spline_scatter
                    markerSize: 8
                    color: temperature_spline.color
                    borderWidth: 2
                    axisX: datetime3
                    axisY: temperatureAxis2
                    borderColor: "white"
                }



                LineSeries {
                    id:humidity_spline
                    name: "Relative Humidity"
                    axisX: datetime3
                    axisYRight:humidityAxis2
                    color: "deepPink"
                    width: 2

                }


                ScatterSeries{
                    id:humidity_spline_scatter
                    markerSize: 8
                    color: humidity_spline.color
                    borderWidth: 2
                    axisX: datetime3
                    axisYRight: humidityAxis2
                    borderColor: "white"
                }








            }

        }





    }

}
