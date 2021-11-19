#include "readings.h"

Readings::Readings(QObject *parent,QString timestamp, double humidity, double temperature) : QObject(parent)
{
    this->Timestamp=timestamp;
    this->Humidity=humidity;
    this->Temperature=temperature;
}

const QString &Readings::get_timestamp()
{
    return Timestamp;

}

const double &Readings::get_humidity()
{
    return Humidity;
}

const double &Readings::get_temperature()
{
    return Temperature;
}

//void Readings::set_timestamp(const QString &_timestamp)
//{
//    this->Timestamp=_timestamp;
//}

//void Readings::set_humidity(const double &_humidity)
//{
//    this->Humidity=_humidity;

//}

//void Readings::set_temperature(const double &_temperature)
//{
//    this->Temperature=_temperature;
//}

