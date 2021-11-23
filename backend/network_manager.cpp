#include "network_manager.h"
#include <QNetworkProxy>
#include <QSslConfiguration>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "readings.h"

NetworkManager::NetworkManager(QObject *parent, DatabaseManager* _database) : QObject(parent),database(_database)
{

#if !(defined(Q_OS_ANDROID) || defined(Q_OS_IOS))

    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("172.16.0.1");
    proxy.setPort(8282);
    QNetworkProxy::setApplicationProxy(proxy);

#endif


    manager = new QNetworkAccessManager(this);
    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::TlsV1_2);
    request.setSslConfiguration(config);

}

void NetworkManager::fetch_http_data(const QString &device_id,const QString& last_timestamp)
{

    device_serialnumber = device_id;
    QString baseUrl="https://warehouse-monitor-app.herokuapp.com/qtapp/data/";
    QString params = device_serialnumber + "/" + last_timestamp;
    request.setUrl(QUrl(baseUrl+params));

    response = manager->get(request);

    connect(response, &QIODevice::readyRead, this, &NetworkManager::http_response_is_ready);
    connect(response, &QNetworkReply::errorOccurred,this, &NetworkManager::internet_connection_failed);

    emit loading_data_from_server();

}

void NetworkManager::internet_connection_failed()
{
    qDebug()<<"failed to connect";
    disconnect(response, &QIODevice::readyRead, this, &NetworkManager::http_response_is_ready);
    disconnect(response, &QNetworkReply::errorOccurred,this, &NetworkManager::loading_error);
    response->deleteLater();
    emit loading_error();

    //////load data from database
    emit load_data_from_database(device_serialnumber);

}


void NetworkManager::http_response_is_ready()
{
    disconnect(response, &QIODevice::readyRead, this, &NetworkManager::http_response_is_ready);
    disconnect(response, &QNetworkReply::errorOccurred,this, &NetworkManager::loading_error);

    int statusCode = response->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QString responseBody = response->readAll();

    response->deleteLater();

    qDebug()<< statusCode <<"\n\n";


    QJsonDocument jsonResponse = QJsonDocument::fromJson(responseBody.toUtf8());
    if(jsonResponse.isNull()){
        emit loading_error();
        //////load data from database
        emit load_data_from_database(device_serialnumber);
        return;
    }

    QJsonObject jsonObject = jsonResponse.object();
    QJsonArray jsonArray = jsonObject["data"].toArray();

    if(jsonArray.empty()){
        ///load data from database
        emit load_data_from_database(device_serialnumber);
        return;
    }


    QString timestamp;  //to record latest timestamp

    for(const auto& value : jsonArray) {

        QJsonObject obj = value.toObject();

        timestamp = obj["date"].toString();
        double humidity = obj["hum"].toDouble();
        double temperature = obj["temp"].toDouble();

        qDebug()<<timestamp<<humidity<<temperature<<"\n\n";

        database->insert_device_readings(device_serialnumber,timestamp,temperature,humidity);

    }

    database->set_device_latest_timestamp(device_serialnumber,timestamp);


    ///load data from database
    emit load_data_from_database(device_serialnumber);


    emit loading_completed_succesfully();

}
