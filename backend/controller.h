#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "backend_global.h"
#include <QObject>
#include "database_manager.h"
#include "readings.h"
#include "device.h"
#include <QVariantList>


class NetworkManager;

class BACKEND_EXPORT Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList load_readings_from_database READ load_readings_from_database CONSTANT)
    Q_PROPERTY(QVariantList get_devices_from_database READ get_devices_from_database CONSTANT)
    Q_PROPERTY(QString selectedOption READ get_selectedOption)
    Q_PROPERTY(QString selectedDate READ get_selectedDate)

public:
    explicit Controller(QObject *parent = nullptr);

    QVariantList load_readings_from_database(); //if rebounce emitted, call this
    QVariantList get_devices_from_database();
    const QString& get_selectedOption();
    const QString& get_selectedDate();

signals:
    void selections_changed();  //listen to this signal to update the options values
    void load_from_db_rebounced(); //listen to this signal to update the readings model
    void Loading_data_from_server();//listen to this signal to show the progress bar
    void Loading_completed_succesfully();//listen to this signal to disable progress bar
    void Loading_error();//listen to this signal to prompt of fetch error
    void device_availability_is_ready(int responseCode);

    void modelChanged(); //rebounced signal to refresh model

public slots:
    void set_selectedOptions(const QString& option,const QString& date);
    void fetch_http_data(const QString& device_id = "", const QString& last_timestamp="0");  //initial request for data
    void check_for_device_availability(const QString& serial_number);
    void addNewDevice(const QString& name,const QString& serialNumber);




private:

    DatabaseManager* database;
    NetworkManager* network;
    QString selectedOption="daily";
    QString selectedDate="0";
    QString device_serialNUmber;

};

#endif // CONTROLLER_H
