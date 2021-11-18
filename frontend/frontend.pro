QT += quick qml quickcontrols2 charts

CONFIG += c++14

INCLUDEPATH += source \
    $$PWD/../backend

include(theme/statusbar.pri)

SOURCES += source/main.cpp

RESOURCES += views.qrc \
    assets.qrc \
    components.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =$$PWD

#win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../my_room_CORE/release/ -lmy_room_CORE
#else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../my_room_CORE/debug/ -lmy_room_CORE
#else:unix:
LIBS += -L$$OUT_PWD/../backend/ -lbackend



# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#DISTFILES += \
#    android/AndroidManifest.xml \
#    android/build.gradle \
#    android/gradle/wrapper/gradle-wrapper.jar \
#    android/gradle/wrapper/gradle-wrapper.properties \
#    android/gradlew \
#    android/gradlew.bat \
#    android/res/values/libs.xml \
#    android/src/enterprise/paddy/pyker/QtAndroidService.java \
#    android/src/enterprise/paddy/pyker/MainActivity.java




contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
