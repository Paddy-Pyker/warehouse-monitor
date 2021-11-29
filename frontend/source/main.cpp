#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "statusbar.h"
#include "controller.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    qmlRegisterType<Controller>("CT", 1, 0, "Controller");
    qmlRegisterType<StatusNavigationBar>("StatusNavigationBar", 0, 1, "StatusNavigationBar");

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
