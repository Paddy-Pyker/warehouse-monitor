#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "backend_global.h"
#include <QObject>
#include "network_manager.h"
#include "database_manager.h"


class BACKEND_EXPORT Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);


private:

    std::unique_ptr<DatabaseManager> database;
    std::unique_ptr<NetworkManager> network;


};

#endif // CONTROLLER_H
