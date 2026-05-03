import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
// Notifications removed — handled elsewhere
import Quickshell.Io

Item {
    id: root
    signal closeRequested()

    // Size panel from laid out content to avoid item overlap.
    implicitHeight: content.implicitHeight + 28

    FontLoader {
        id: jetbrainsMonoFont
        source: "JetBrainsMonoNerdFont-Regular.ttf"
    }

    readonly property string fontFamily: (jetbrainsMonoFont.status === FontLoader.Ready && jetbrainsMonoFont.name && jetbrainsMonoFont.name.trim().length > 0)
        ? jetbrainsMonoFont.name
        : "JetBrainsMono NF"

    MatugenColors { id: colors }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
        propagateComposedEvents: true
        onPressed: (mouse) => mouse.accepted = false
    }

    Rectangle {
        id: panelBg
        anchors.fill: parent
        color: Qt.rgba(0.06, 0.07, 0.08, 0.9)
        radius: 16

        ColumnLayout {
            id: content
            anchors {
                fill: parent
                margins: 14
            }
            spacing: 5

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "  " 
                    font.family: root.fontFamily
                    font.pixelSize: 15
                    color: colors.text
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 28; height: 28
                    radius: 8
                    color: closeHover.containsMouse ? colors.surface1 : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        font.family: root.fontFamily
                        font.pixelSize: 16
                        color: colors.overlay1
                    }
                    MouseArea {
                        id: closeHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.closeRequested()
                    }
                    Behavior on color { ColorAnimation { duration: 80 } }
                }
            }
            
            WifiCard {
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
            }

            BluetoothCard {
                Layout.bottomMargin: 2
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
            }

            SystemInfoRow {
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
            }

            ToggleGrid {
                Layout.topMargin: -6
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
            }


            SliderRow {
                Layout.topMargin: 15
                Layout.bottomMargin: 5
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
            }

        }
    }

}
