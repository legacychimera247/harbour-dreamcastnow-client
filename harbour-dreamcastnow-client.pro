TARGET = harbour-dreamcastnow-client

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-dreamcastnow-client.qml \
    qml/cover/CoverPage.qml \
    qml/js/dom-parser.js \
    qml/js/worker.js \
    qml/pages/AboutPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SettingsPage.qml \
    rpm/harbour-dreamcastnow-client.changes.in \
    rpm/harbour-dreamcastnow-client.changes.run.in \
    rpm/harbour-dreamcastnow-client.spec \
    translations/*.ts \
    harbour-dreamcastnow-client.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-dreamcastnow-client-ru.ts \
    translations/harbour-dreamcastnow-client-it.ts

images.files = images
images.path = /usr/share/$${TARGET}

INSTALLS += images
