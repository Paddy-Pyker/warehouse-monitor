#include "controller.h"
#include <QDebug>


Controller::Controller(QObject *parent) : QObject(parent)
{

    database = new DatabaseManager(this);
    network = std::make_unique<NetworkManager>(this,database);

}






