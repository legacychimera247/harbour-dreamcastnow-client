import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/emoji.js" as Emoji

Page {
    id: page
    allowedOrientations: Orientation.All

    Timer {
        // Keep this here to only update when this page is active
        running: (Qt.application.state === Qt.ApplicationActive) ? config.backgroundAutoUpdate : (config.autoUpdate && page.status == PageStatus.Active)
        repeat: true
        interval: ((Qt.application.state === Qt.ApplicationActive) ? config.updateInterval : config.backgroundUpdateInterval) * 1000
        onTriggered: update()
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        opacity: loading ? 0 : 1
        Behavior on opacity { FadeAnimator {} }

        model: usersModel

        PullDownMenu {
            busy: appWindow.refreshing && !appWindow.loading

            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push("AboutPage.qml")
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push("SettingsPage.qml")
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    appWindow.refreshing = true
                    appWindow.update()
                }
            }
        }

        header: PageHeader { title: "Dreamfish Now" }

        section.property: 'status'
        section.delegate: SectionHeader {
            text: section ? qsTr("%Ln online", '', onlineCount) : qsTr("Offline")
        }

        delegate: Item {
            width: parent.width
            height: listItem.height + (separator.visible ? (separator.height + separator.anchors.topMargin*2) : 0)
            ListItem {
                id: listItem
                contentHeight: contentContainer.height

                Item {
                    id: contentContainer
                    width: parent.width
                    height: contentColumn.height
                    Loader {
                        active: config.showBackground && !!background
                        anchors.fill: parent
                        sourceComponent: Component {
                            Image {
                                anchors.fill: parent
                                source: background
                                fillMode: Image.PreserveAspectCrop

                                Rectangle {
                                    anchors.fill: parent
                                    color: Theme.overlayBackgroundColor
                                    opacity: Theme.opacityOverlay
                                    visible: parent.status == Image.Ready
                                }
                            }
                        }
                    }


                    Column {
                        id: contentColumn
                        x: Theme.horizontalPageMargin
                        topPadding: Theme.paddingMedium
                        bottomPadding: Theme.paddingMedium
                        width: parent.width - 2*x
                        spacing: Theme.paddingMedium

                        Row {
                            width: parent.width
                            spacing: Theme.paddingMedium

                            Column {
                                id: textColumn
                                width: parent.width - avatarImage.width - parent.spacing*1
                                spacing: Theme.paddingMedium

                                Label {
                                    width: parent.width
                                    truncationMode: TruncationMode.Fade
                                    font.pixelSize: Theme.fontSizeMedium
                                    text: Emoji.emojify(username, Theme.fontSizeMedium)
                                }

                                Repeater {
                                    model: [playing, level]
                                    Label {
                                        width: parent.width
                                        truncationMode: TruncationMode.Fade
                                        font.pixelSize: Theme.fontSizeSmall
                                        text: Emoji.emojify(modelData, Theme.fontSizeSmall)
                                        visible: !!text
                                    }
                                }

                                Label {
                                    width: parent.width
                                    truncationMode: TruncationMode.Fade
                                    font.pixelSize: Theme.fontSizeSmall
                                    text: Emoji.emojify(lastSeen, Theme.fontSizeSmall)
                                    //font.bold: lastSeenBold
                                    color: lastSeenBold
                                           ? (highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)
                                           : (highlighted ? Theme.highlightColor : Theme.primaryColor)
                                }
                            }

                            Image {
                                id: avatarImage
                                width: Theme.iconSizeExtraLarge
                                height: width
                                source: avatar
                            }
                        }

                        Column {
                            width: parent.width
                            spacing: Theme.paddingSmall
                            visible: recentlyPlayed.count > 0
                            Label {
                                anchors.topMargin: visible ? Theme.paddingLarge : 0
                                font.pixelSize: Theme.fontSizeLarge
                                text: qsTr("Played recently:")
                            }

                            Flow {
                                width: parent.width
                                spacing: Theme.paddingMedium
                                Repeater {
                                    model: recentlyPlayed
                                    Image {
                                        width: Theme.iconSizeLarge
                                        height: width
                                        source: gameIcon
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Separator {
                id: separator
                anchors.top: listItem.bottom
                anchors.topMargin: config.separators > 1 ? Theme.paddingSmall : height
                width: parent.width
                horizontalAlignment: Qt.AlignCenter
                color: Theme.primaryColor
                visible: config.separators > 0
            }
        }

        VerticalScrollDecorator {}
    }

    BusyLabel {
        running: loading
    }
}
