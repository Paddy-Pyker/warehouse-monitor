#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "database_manager.h"


class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent, DatabaseManager* _database);


signals:
    void loading_data_from_server();
    void loading_completed_succesfully();
    void loading_error();

public slots:

    void fetch_http_data(const QString& device_id = "", const QString& last_timestamp="0");
    void http_response_is_ready();
    void internet_connection_failed();


private:


    QNetworkAccessManager* manager;
    QNetworkReply* response;
    QNetworkRequest request;
    QString device_serialnumber;
    DatabaseManager* database;
};

#endif // NETWORKMANAGER_H
