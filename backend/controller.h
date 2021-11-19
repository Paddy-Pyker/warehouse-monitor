#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "backend_global.h"
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QList>
#include "readings.h"


class BACKEND_EXPORT Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

signals:
    void loading_data_from_server();
    void loading_completed_succesfully();
    void loading_error();

public slots:
    void fetch_http_data(const QString& device_id = "");
    void http_response_is_ready();
    void internet_connection_failed();


private:
    QNetworkAccessManager* manager;
    QNetworkReply* response;
    QNetworkRequest request;
    QString device_id;
    QList<std::shared_ptr<Readings>> total_readings;


};

#endif // CONTROLLER_H
