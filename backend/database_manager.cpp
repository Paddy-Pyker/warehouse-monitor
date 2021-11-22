#include "database_manager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QSqlError>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{

    if (initialise()) {
        qDebug() << "Database is ready and is using Sqlite version: " + sqliteVersion();

        if (create_tables()) {
            qDebug() << "Database tables are ready";
        } else {
            qDebug() << "ERROR: Unable to create database tables";
        }

    } else {
        qDebug() << "ERROR: Unable to open database";
    }



}

bool DatabaseManager::initialise()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName( "warehouse_monitor.db" );


#if (defined(Q_OS_ANDROID) || defined(Q_OS_IOS))

    QFile export_database_file(":/assets/warehouse_monitor.db");
    QString destinationFile = QStandardPaths::writableLocation(QStandardPaths::HomeLocation).append("/warehouse_monitor.db");

    if(!QFile::exists(destinationFile))
    {
        export_database_file.copy(destinationFile);
        QFile::setPermissions(destinationFile,QFile::WriteOwner | QFile::ReadOwner);
    }

    db.setDatabaseName(destinationFile);

#endif

    return db.open();
}





bool DatabaseManager::create_tables()
{

    QSqlQuery query;
    query.prepare("CREATE TABLE IF NOT EXISTS device_name ("
                  "serial_number VARCHAR(255) NOT NULL,"
                  "name VARCHAR(255) NOT NULL,"
                  "created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
                  "last_reading_timestamp VARCHAR(255) DEFAULT NULL,"
                  "PRIMARY KEY(serial_number))");


    QSqlQuery query2;
    query2.prepare("CREATE TABLE IF NOT EXISTS device_readings ("
                   "id INTEGER NOT NULL,"
                   "serial_number VARCHAR(255) NOT NULL,"
                   "temperature DOUBLE(255) NOT NULL,"
                   "humidity DOUBLE(255) NOT NULL,"
                   "moisture_content DOUBLE(255) NOT NULL,"
                   "timestamp VARCHAR(255) NOT NULL,"
                   "year VARCHAR(10) NOT NULL,"
                   "month VARCHAR(10) NOT NULL,"
                   "day VARCHAR(10) NOT NULL,"
                   "time VARCHAR(10) NOT NULL,"
                   "FOREIGN KEY(serial_number) REFERENCES device_name(serial_number),"
                   "PRIMARY KEY(id AUTOINCREMENT))");

    return query.exec() && query2.exec();
}


QString DatabaseManager::sqliteVersion() const
{

    QSqlQuery query("SELECT sqlite_version()");

    if (query.next()) return query.value(0).toString();

    return QString::number(-1);

}
