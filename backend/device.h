#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include "backend_global.h"

class BACKEND_EXPORT Device : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString serialNumber READ serialNumber CONSTANT)
    Q_PROPERTY(QString last_reading_timestamp READ last_reading_timestamp CONSTANT)

public:
    explicit Device(QObject *parent = nullptr,const QString& name = "",
                    const QString& serial_number = "",
                    const QString& last_reading_timestamp = ""
            );

    const QString& name();
    const QString& serialNumber();
    const QString& last_reading_timestamp();


private:
    QString Name;
    QString SerialNumber;
    QString lastReadingTimestamp;

};

#endif // DEVICE_H
