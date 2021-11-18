#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "backend_global.h"
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>


class BACKEND_EXPORT Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

    //signals:

public slots:
    void http_response_is_ready();
    void internet_connection_failed();


private:
    QNetworkAccessManager* manager;
    QNetworkRequest request;
    QNetworkReply* response;

};

#endif // CONTROLLER_H
