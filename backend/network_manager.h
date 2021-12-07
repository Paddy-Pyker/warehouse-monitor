#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "database_manager.h"
#include "controller.h"


class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent, DatabaseManager* _database);

    void fetch_http_data(const QString &device_id,const QString& last_timestamp);
    void check_for_device_availability(const QString& serial_number);


signals:
    void loading_data_from_server();
    void loading_completed_succesfully();
    void loading_error();
    void load_data_from_database(const QString& serial_number);

    void device_AVAILABILITY_IS_READY(int response);

private slots:
    void http_response_is_ready();
    void internet_connection_failed();

    void device_availability_is_ready();
    void device_availability_error_occurred();


private:

    DatabaseManager* database;
    QNetworkAccessManager* manager;
    QNetworkReply* response;
    QNetworkRequest request;
    QString device_serialnumber;

};

#endif // NETWORKMANAGER_H
