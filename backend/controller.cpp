#include "controller.h"
#include <QDebug>
#include <QNetworkProxy>
#include <QSslConfiguration>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>




Controller::Controller(QObject *parent) : QObject(parent)
{
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("192.168.42.129");
    proxy.setPort(8181);
    QNetworkProxy::setApplicationProxy(proxy);



    manager = new QNetworkAccessManager(this);
    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::TlsV1_2);
    request.setSslConfiguration(config);

    fetch_http_data("1");


}

void Controller::fetch_http_data(const QString &device_id)
{

    this->device_id = device_id;
    QString baseUrl="https://warehouse-monitor-app.herokuapp.com/qtapp/data/";
    request.setUrl(QUrl(baseUrl+this->device_id));

    response = manager->get(request);

    connect(response, &QIODevice::readyRead, this, &Controller::http_response_is_ready);
    connect(response, &QNetworkReply::errorOccurred,this, &Controller::internet_connection_failed);

    emit loading_data_from_server();

}

void Controller::http_response_is_ready()
{
    disconnect(response, &QIODevice::readyRead, this, &Controller::http_response_is_ready);
    disconnect(response, &QNetworkReply::errorOccurred,this, &Controller::loading_error);

    int statusCode = response->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QString responseBody = response->readAll();

    response->deleteLater();

    qDebug()<< statusCode <<"\n\n";


    QJsonDocument jsonResponse = QJsonDocument::fromJson(responseBody.toUtf8());
    if(jsonResponse.isNull())
        fetch_http_data(this->device_id);

    QJsonObject jsonObject = jsonResponse.object();
    QJsonArray jsonArray = jsonObject["data"].toArray();


    for(const auto& value : jsonArray) {

        QJsonObject obj = value.toObject();

        QString timestamp = obj["date"].toString();
        double humidity = obj["hum"].toDouble();
        double temperature = obj["temp"].toDouble();

        auto device_readings = std::make_shared<Readings>(this,timestamp,humidity,temperature);


        total_readings.append(device_readings);

    }

    //    for(int i = 0;i<10;i++){
    //        QString timestamp = "13th february 2021";
    //        double humidity = 52.32;
    //        double temperature = 34;

    //        Readings* device_readings = new Readings(this,timestamp,humidity,temperature);
    //        total_readings.append(device_readings);
    //        delete device_readings;

    //    }


    for(const auto& device : total_readings){
        qDebug()<<device->get_humidity()<<device->get_temperature()<<device->get_timestamp()<<"\n\n";
    }



    /////////////////////////////

    emit loading_completed_succesfully();

}

void Controller::internet_connection_failed()
{
    qDebug()<<"failed to connect";
    disconnect(response, &QIODevice::readyRead, this, &Controller::http_response_is_ready);
    disconnect(response, &QNetworkReply::errorOccurred,this, &Controller::loading_error);
    response->deleteLater();
    emit loading_error();
}
