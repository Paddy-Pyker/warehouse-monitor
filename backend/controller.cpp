#include "controller.h"
#include <QDebug>
#include <QNetworkProxy>
#include <QSslConfiguration>



Controller::Controller(QObject *parent) : QObject(parent)
{
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("192.168.42.129");
    proxy.setPort(8181);
    QNetworkProxy::setApplicationProxy(proxy);



    manager = new QNetworkAccessManager(this);

    request.setUrl(QUrl("http://warehouse-monitor-app.herokuapp.com/qtapp/data/1"));
    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setProtocol(QSsl::TlsV1_2);
    request.setSslConfiguration(config);

    response = manager->get(request);

    connect(response, &QIODevice::readyRead, this, &Controller::http_response_is_ready);
    connect(response, &QNetworkReply::errorOccurred,this, &Controller::internet_connection_failed);



}

void Controller::http_response_is_ready()
{
    disconnect(response, &QIODevice::readyRead, this, &Controller::http_response_is_ready);
    disconnect(response, &QNetworkReply::errorOccurred,this, &Controller::internet_connection_failed);

    int statusCode = response->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QString responseBody = response->readAll();

    response->deleteLater();

    qDebug()<< statusCode;

    qDebug()<< responseBody;


}

void Controller::internet_connection_failed()
{
    qDebug()<<"failed to connect";
}
