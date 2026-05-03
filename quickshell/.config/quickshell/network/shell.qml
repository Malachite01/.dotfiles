//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import "./network/"

ShellRoot {

    id: root

    FontLoader {
        id: panelFont
        source: "/home/pandora/.dotfiles/quickshell/.config/quickshell/panel/JetBrainsMonoNerdFont-Regular.ttf"
    }

    MatugenColors { id: colors }

    property bool networkVisible: false
    property string requestedMode: ""

    function normalizeMode(mode: string): string {
        if (mode === "network" || mode === "wifi") return "wifi";
        if (mode === "bluetooth" || mode === "bt") return "bt";
        return "";
    }

    IpcHandler {
        target: "network"

        function toggle(): void {
            networkVisible = !networkVisible;
        }

        function showNetwork(): void {
            root.requestedMode = "wifi";
            networkVisible = true;
        }

        function showBluetooth(): void {
            root.requestedMode = "bt";
            networkVisible = true;
        }
    }

    Variants {
        model: Quickshell.screens

        Window {
            id: networkWindow

            property var modelData
            screen: modelData

            onClosing: function(close) {
                close.accepted = false;
                networkVisible = false;
            }

            visible: networkVisible && (modelData === Quickshell.screens[0])
            flags: Qt.Window | Qt.FramelessWindowHint
            width: 580
            height: 920
            x: modelData.geometry.x + modelData.geometry.width - width - 20
            y: modelData.geometry.y + 20

            color: "transparent"

            NetworkPopup {
                shellRoot: root
                requestedMode: root.requestedMode
                anchors.fill: parent
            }

            Rectangle {
                id: closeButton
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 8
                anchors.rightMargin: 8
                width: 28
                height: 28
                radius: 8
                color: mouseArea.containsMouse ? colors.surface1 : "#1f1f1f1f"
                z: 10

                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: colors.text
                    font.family: panelFont.status === FontLoader.Ready ? panelFont.name : "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    font.bold: true
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: networkVisible = false
                }
            }
        }
    }
}
