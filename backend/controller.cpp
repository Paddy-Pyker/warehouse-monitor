#include "network_manager.h"
#include "controller.h"


Controller::Controller(QObject *parent) : QObject(parent)
{
    database = new DatabaseManager(this);
    network = new NetworkManager(this,database);

    connect(network,&NetworkManager::load_data_from_database,this,[=](QString a){
        device_serialNUmber = a;
        emit load_from_db_rebounced();
    },Qt::AutoConnection);

    connect(network,&NetworkManager::loading_error,this,&Controller::Loading_error);
    connect(network,&NetworkManager::loading_completed_succesfully,this,&Controller::Loading_completed_succesfully);
    connect(network,&NetworkManager::loading_data_from_server,this,&Controller::Loading_data_from_server);


    network->fetch_http_data("1","0"); /// for testing purposes
}

QQmlListProperty<Readings> Controller::load_readings_from_database()
{
    QList<Readings*> a = database->load_readings_from_database(device_serialNUmber,selectedOption,selectedDate);

    return QQmlListProperty<Readings>(this,&a);
}

const QString &Controller::get_selectedOption()
{
    return selectedOption;
}

const QString &Controller::get_selectedDate()
{
    return selectedDate;
}

void Controller::set_selectedOptions(const QString &option, const QString &date)
{
    if(selectedOption == option && selectedDate == date)
        return;

    selectedDate = date;
    selectedOption = option;

    emit selections_changed();
}

void Controller::fetch_http_data(const QString &device_id, const QString &last_timestamp)
{
    network->fetch_http_data(device_id,last_timestamp);
}






