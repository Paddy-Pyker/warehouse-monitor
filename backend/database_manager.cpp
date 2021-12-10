#include "database_manager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QSqlError>
#include <QDateTime>

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

void DatabaseManager::set_device_latest_timestamp(const QString &serial_number, const QString &timestamp)
{

    QSqlQuery query;
    query.prepare("UPDATE device_name set last_reading_timestamp=:timestamp WHERE serial_number=:serial_number");
    query.bindValue(":timestamp",timestamp);
    query.bindValue(":serial_number",serial_number);

    if(query.exec())
    qDebug()<<"query worked";



}

void DatabaseManager::insert_device_readings(const QString& serial_number,const QString &_timestamp, const double &temperature, const double &humidity, const double &moisture_content)
{

    QDateTime time = QDateTime::fromMSecsSinceEpoch(_timestamp.toULongLong()*1000,Qt::UTC);

    const QString TIMESTAMP = QString::number(_timestamp.toULongLong()*1000);
    QString YEAR = time.toString("yyyy");
    QString MONTH = time.toString("MMM");
    QString DAY = time.toString("ddd d");
    QString TIME = time.toString("h:mm ap");

    QSqlQuery query;
    query.prepare("INSERT INTO device_readings "
                  "(serial_number,temperature,humidity,moisture_content,timestamp,year,month,day,time) "
                  "VALUES (:serial_number,:temperature,:humidity,:moisture_content,:timestamp,:year,:month,:day,:time)"
                  );

    query.bindValue(":serial_number",serial_number);
    query.bindValue(":temperature",temperature);
    query.bindValue(":humidity",humidity);
    query.bindValue(":moisture_content",moisture_content);
    query.bindValue(":timestamp",TIMESTAMP);
    query.bindValue(":year",YEAR);
    query.bindValue(":month",MONTH);
    query.bindValue(":day",DAY);
    query.bindValue(":time",TIME);
    query.exec();

}

int DatabaseManager::device_availability(const QString &device_serialnumber)
{
    QSqlQuery query;
    query.prepare("SELECT serial_number FROM device_name WHERE serial_number=:serial_number");
    query.bindValue(":serial_number",device_serialnumber);
    query.exec();
    if (query.next())  return 0;

    return 201;



}

void DatabaseManager::addNewDevice(const QString &name, const QString &serialNumber)
{
    QSqlQuery query;
    query.prepare("INSERT INTO device_name(name,serial_number) VALUES(:name,:serial_number)");
    query.bindValue(":name",name);
    query.bindValue(":serial_number",serialNumber);
    query.exec();
}

void DatabaseManager::deleteDevice(const QString &serial_number)
{
    QSqlQuery query;
    query.prepare("DELETE FROM device_name WHERE serial_number = :serial_number");
    query.bindValue(":serial_number",serial_number);
    query.exec();
}

void DatabaseManager::renameDevice(const QString& serialNumber,const QString &newName)
{
    QSqlQuery query;
    query.prepare("UPDATE device_name SET name=:name WHERE serial_number=:serial_number");
    query.bindValue(":name",newName);
    query.bindValue(":serial_number",serialNumber);
    query.exec();
}

QVariantList DatabaseManager::load_readings_from_database(const QString& _serial_number,const QString& _selectedOption,const QString& _selectedDate)
{

    QDateTime time = QDateTime::fromMSecsSinceEpoch(_selectedDate.toULongLong(),Qt::UTC);  //ensure selectedDate is in ms

    QString serial_number = _serial_number;
    QString option = _selectedOption;
    QString year = time.toString("yyyy");
    QString month = time.toString("MMM");
    QString day = time.toString("ddd d");

    QSqlQuery query;

    if(option == "daily"){
        QString query_string = "SELECT temperature,humidity,timestamp from device_readings "
                               "WHERE serial_number=:serial_number GROUP by time "
                               "HAVING year=:year and month=:month and day=:day "
                               "ORDER by timestamp LIMIT 10";

        query.prepare(query_string);
        query.bindValue(":serial_number",serial_number);
        query.bindValue(":year",year);
        query.bindValue(":month",month);
        query.bindValue(":day",day);

    } else if (option == "weekly") {

        QString query_string = "SELECT Round(AVG(temperature),2) as temperature,"
                               "Round(AVG(humidity),2) as humidity,"
                               "timestamp from device_readings "
                               "WHERE serial_number=:serial_number "
                               "GROUP by day HAVING year=:year and "
                               "month=:month ORDER by timestamp LIMIT 7";

        query.prepare(query_string);
        query.bindValue(":serial_number",serial_number);
        query.bindValue(":year",year);
        query.bindValue(":month",month);

    } else if (option == "monthly") {

        QString query_string = "SELECT Round(AVG(temperature),2) as temperature,"
                               "Round(AVG(humidity),2) as humidity,"
                               "timestamp from device_readings "
                               "WHERE serial_number=:serial_number "
                               "GROUP by month HAVING year=:year"
                               " ORDER by timestamp LIMIT 10";

        query.prepare(query_string);
        query.bindValue(":serial_number",serial_number);
        query.bindValue(":year",year);

    } else if (option == "annually") {

        QString query_string = "SELECT Round(AVG(temperature),2) as temperature,"
                               "Round(AVG(humidity),2) as humidity,"
                               "timestamp from device_readings "
                               "WHERE serial_number=:serial_number "
                               "GROUP by year ORDER by timestamp";

        query.prepare(query_string);
        query.bindValue(":serial_number",serial_number);
    } else {


        QString query_string = "SELECT temperature,humidity,timestamp from device_readings"
                               " WHERE serial_number=:serial_number "
                               "ORDER by timestamp DESC LIMIT 10";

        query.prepare(query_string);
        query.bindValue(":serial_number",serial_number);
    }


    query.exec();
    QVariantList list_of_readings;

    while (query.next()) {

        Readings* readings =  new Readings(this,query.value("timestamp").toString(),
                                           query.value("humidity").toDouble(),
                                           query.value("temperature").toDouble());


        list_of_readings.push_front(QVariant::fromValue(readings));
    }


    return list_of_readings;
}

QVariantList DatabaseManager::get_devices_from_database()
{


    QSqlQuery query("SELECT name,serial_number,last_reading_timestamp FROM device_name ORDER BY created_at DESC");


    QVariantList devices;


    while(query.next()) {


        Device* device = new Device(this,query.value("name").toString(),
                                    query.value("serial_number").toString(),
                                    query.value("last_reading_timestamp").toString());

        devices.append(QVariant::fromValue(device));

    }

    return devices;

}

QVariantList DatabaseManager::searchDevice(const QString &searchText)
{
    QSqlQuery query;
    query.prepare("SELECT name,serial_number,last_reading_timestamp "
                  "FROM device_name WHERE name like :searchText "
                  "OR serial_number like :searchText ORDER BY created_at DESC");

    query.bindValue(":searchText",QVariant("%" + searchText + "%"));

    query.exec();

    QVariantList filteredDevices;

    while (query.next()) {
        Device* device = new Device(this,query.value("name").toString(),
                                    query.value("serial_number").toString(),
                                    query.value("last_reading_timestamp").toString());
        filteredDevices.append(QVariant::fromValue(device));
    }


    return filteredDevices;
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
                   "FOREIGN KEY(serial_number) REFERENCES device_name(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,"
                   "PRIMARY KEY(id AUTOINCREMENT))");

    return query.exec() && query2.exec();
}


QString DatabaseManager::sqliteVersion() const
{

    QSqlQuery query("SELECT sqlite_version()");

    if (query.next()) return query.value(0).toString();

    return QString::number(-1);

}


