#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "statusbar.h"
#include "controller.h"
#include "device.h"
#include "readings.h"



int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    qmlRegisterType<Controller>("Controller", 1, 0, "Controller");
    qmlRegisterType<Device>("Device", 1, 0, "Device");
    qmlRegisterType<Readings>("Readings", 1, 0, "Readings");

    StatusNavigationBar color;
    Controller* controller = new Controller(&app);
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/");
    engine.rootContext()->setContextProperty("colorBar", &color);
    engine.rootContext()->setContextProperty("controller", controller);

    const QUrl url(QStringLiteral("qrc:/views/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
