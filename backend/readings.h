#ifndef READINGS_H
#define READINGS_H

#include <QObject>
#include <backend_global.h>

class BACKEND_EXPORT Readings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString timestamp READ get_timestamp CONSTANT)
    Q_PROPERTY(double humidity READ get_humidity CONSTANT)
    Q_PROPERTY(double temperature READ get_temperature CONSTANT)
public:
    explicit Readings(QObject *parent = nullptr, QString timestamp="", double humidy=0, double temperature=0);

//signals:
public:
    const QString& get_timestamp();
    const double& get_humidity();
    const double& get_temperature();

//    void set_timestamp(const QString& _timestamp);
//    void set_humidity(const double& _humidity);
//    void set_temperature(const double& _temperature);

private:
    QString Timestamp;
    double Humidity;
    double Temperature;

};

#endif // READINGS_H
