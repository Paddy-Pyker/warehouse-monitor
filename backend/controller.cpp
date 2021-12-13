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
    connect(network,&NetworkManager::device_AVAILABILITY_IS_READY,this,&Controller::device_availability_is_ready);


    // network->fetch_http_data("1","0"); /// for testing purposes
}

QVariantList Controller::load_readings_from_database()
{
    return database->load_readings_from_database(device_serialNUmber,selectedOption,selectedDate);
}

QVariantList Controller::get_devices_from_database()
{

    return database->get_devices_from_database();
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

    emit load_from_db_rebounced();
}

void Controller::fetch_http_data(const QString &device_id, const QString &last_timestamp)
{
    network->fetch_http_data(device_id,last_timestamp);
}

void Controller::check_for_device_availability(const QString &serial_number)
{
    network->check_for_device_availability(serial_number);
}

void Controller::addNewDevice(const QString &name, const QString &serialNumber)
{
    database->addNewDevice(name,serialNumber);
}

void Controller::deleteDevice(const QString &serial_number)
{
    database->deleteDevice(serial_number);
}

void Controller::renameDevice(const QString &serialNumber, const QString &newName)
{
    database->renameDevice(serialNumber,newName);
}

void Controller::searchDevice(const QString &searchText)
{
    emit modelChanged_SearchResult(database->searchDevice(searchText));
}






