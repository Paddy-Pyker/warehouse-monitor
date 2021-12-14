QT += quick qml charts sql quickcontrols2

INCLUDEPATH += source \
    $$PWD/../backend

include(theme/statusbar.pri)
android: include(android_openssl/openssl.pri)

SOURCES += source/main.cpp

RESOURCES += views.qrc \
    assets.qrc \
    components.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =$$PWD

#win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../my_room_CORE/release/ -lmy_room_CORE
#else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../my_room_CORE/debug/ -lmy_room_CORE
#else:unix:
LIBS += -L$$OUT_PWD/../backend/ -lbackend_armeabi-v7a



# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target



#contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
#}

DISTFILES += \
    android/AndroidManifest.xml \
    android/AndroidManifest.xml \
#    android/build.gradle \
#    android/gradle.properties \
#    android/gradle/wrapper/gradle-wrapper.jar \
#    android/gradle/wrapper/gradle-wrapper.properties \
#    android/gradlew \
#    android/gradlew.bat \
 \ #   android/res/values/libs.xml
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_EXTRA_LIBS = /home/atsu/warehouse-monitor/frontend/android_openssl/latest/arm/libcrypto_1_1.so /home/atsu/warehouse-monitor/frontend/android_openssl/latest/arm/libssl_1_1.so /home/atsu/warehouse-monitor/frontend/../../build-warehouse-monitor-Android_Qt_5_15_2_Clang_Multi_Abi-Release/backend/libbackend_armeabi-v7a.so






