#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <readings.h>
#include <device.h>
#include <QVariantList>


class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    void set_device_latest_timestamp(const QString& serial_number,const QString& timestamp);
    void insert_device_readings(const QString& _serial_number,const QString& timestamp,const double& temperature,
                                const double& humidity,const double& moisture_content=0.0);

    QVariantList load_readings_from_database(const QString& _serial_number, const QString& _selectedOption, const QString& _selectedDate);
    QVariantList get_devices_from_database();

private:
    bool initialise();
    bool create_tables();
    QString sqliteVersion() const;
};

#endif // DATABASEMANAGER_H
