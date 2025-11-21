import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import Nemo.Configuration 1.0

ApplicationWindow {
    id: appWindow
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    property bool loading: true
    property bool refreshing
    property int onlineCount

    property string defaultBackground: config.host + '/static/img/games/backgrounds/UNKNOWN.jpg'

    WorkerScript {
        id: worker
        source: Qt.resolvedUrl("js/worker.js")

        onMessage: {
            if (messageObject === 'loaded')
                loading = refreshing = false
            else
                onlineCount = messageObject
        }
    }

    function update() {
        worker.sendMessage({
                               model: usersModel,
                               defaultBackground: defaultBackground,
                               host: config.host,
                               pagePath: config.pagePath
                           })
    }

    ListModel { id: usersModel }

    Connections {
        target: config
        onHostChanged: {
            loading = true
            update()
        }
        onPagePathChanged: {
            loading = true
            update()
        }
    }

    Component.onCompleted: update()

    ConfigurationGroup {
        id: config
        path: '/apps/harbour-dreamcastnow-client/'

        property string host: 'https://dreamcast.online'
        property string pagePath: '/now/'
        property bool autoUpdate: true
        property real updateInterval: 30 // while real value can't be customized in the app, it can be by editing dconf value manually
        property bool backgroundAutoUpdate: true
        property real backgroundUpdateInterval: 1800 // 30 minutes
        property bool showBackground: true
        property int separators: 0 // 0 - no, 1 - separators, 2 - with padding
    }
}
