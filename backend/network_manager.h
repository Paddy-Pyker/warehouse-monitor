#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>


class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);


signals:
    void loading_data_from_server();
    void loading_completed_succesfully();
    void loading_error();

public slots:

    void fetch_http_data(const QString& device_id = "", const QString& last_timestamp="0");
    void http_response_is_ready();
    void internet_connection_failed();


private:
    void set_device_last_reading_timestamp(const QString& last_reading_timestamp = "");

    QNetworkAccessManager* manager;
    QNetworkReply* response;
    QNetworkRequest request;
    QString device_serialnumber;
};

#endif // NETWORKMANAGER_H
