#include "device.h"

Device::Device(QObject *parent, const QString &name,
               const QString &serial_number, const QString &last_reading_timestamp)
    :QObject(parent),Name(name),SerialNumber(serial_number),lastReadingTimestamp(last_reading_timestamp)
{

}

const QString &Device::name()
{
    return Name;
}

const QString &Device::serialNumber()
{
    return SerialNumber;
}

const QString &Device::last_reading_timestamp()
{
    return lastReadingTimestamp;
}

