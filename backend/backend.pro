QT -= gui
android: QT += androidextras
QT += network

TEMPLATE = lib
DEFINES += BACKEND_LIBRARY

CONFIG += c++14

SOURCES += \
    controller.cpp

HEADERS += \
    backend_global.h \
    controller.h

# Default rules for deployment.
unix {
    target.path = /usr/lib
}
!isEmpty(target.path): INSTALLS += target
