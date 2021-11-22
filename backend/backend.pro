QT -= gui
android: QT += androidextras
QT += network sql

TEMPLATE = lib
DEFINES += BACKEND_LIBRARY

CONFIG += c++14

SOURCES += \
    controller.cpp \
    database_manager.cpp \
    network_manager.cpp \
    readings.cpp

HEADERS += \
    backend_global.h \
    controller.h \
    database_manager.h \
    network_manager.h \
    readings.h

# Default rules for deployment.
unix {
    target.path = /usr/lib
}
!isEmpty(target.path): INSTALLS += target
