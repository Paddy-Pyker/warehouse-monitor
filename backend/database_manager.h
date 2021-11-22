#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>


class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

signals:

private:
    bool initialise();
    bool create_tables();
    QString sqliteVersion() const;
};

#endif // DATABASEMANAGER_H
