import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All

    property string domParserLicense: 'Copyright (c) 2015(s), Konstantin Ershov

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.'

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: "Dreamfish Now"
            }

            Image {
                source: Qt.resolvedUrl('../../images/harbour-dreamcastnow-client.svg')
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge * 2
                height: width
                sourceSize {
                    width: width
                    height: height
                }
            }

            Item {width: 1; height: Theme.paddingLarge}

            Column {
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.Wrap
                    color: Theme.highlightColor
                    text: qsTr("This project is licensed under GNU GPL 3.0. Copyright (c) 2025 roundedrectangle")
                }

                ButtonLayout {
                    Button {
                        text: qsTr("GitHub")
                        onClicked: Qt.openUrlExternally('https://github.com/roundedrectangle/harbour-dreamcastnow-client')
                    }
                }


                SectionHeader { text: qsTr("Translations") }

                DetailItem {
                    label: qsTr("Italian")
                    value: "legacychimera247"
                }


                SectionHeader { text: "dom-parser" }

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    wrapMode: Text.Wrap
                    color: Theme.highlightColor
                    text: qsTr("This project uses a modified version of the dom-parser project, licensed under ISC.")
                }

                ButtonLayout {
                    Button {
                        text: "GitHub"
                        onClicked: Qt.openUrlExternally('https://github.com/ershov-konst/dom-parser')
                    }
                    Button {
                        text: qsTr("ISC License")
                        onClicked: pageStack.push(licensePage, {title: text, content: domParserLicense})
                    }
                }


                Item {width: 1; height: Theme.paddingLarge}
            }
        }

        Component {
            id: licensePage
            Page {
                property alias title: licenseHeader.title
                property alias content: licenseLabel.text
                SilicaFlickable {
                    anchors.fill: parent
                    contentHeight: licenseColumn.height
                    Column {
                        id: licenseColumn
                        width: parent.width

                        PageHeader { id: licenseHeader }
                        Label {
                            id: licenseLabel
                            x: Theme.horizontalPageMargin
                            width: parent.width - 2*x
                        }
                    }
                }
            }
        }
    }
}
