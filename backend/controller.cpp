#include "controller.h"
#include <QDebug>


Controller::Controller(QObject *parent) : QObject(parent)
{

    database = std::make_unique<DatabaseManager>(this);
    network = std::make_unique<NetworkManager>(this);

}






