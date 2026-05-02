//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "./network/"

ShellRoot {

    property bool networkVisible: false

    IpcHandler {
        target: "network"

        function toggle(): void {
            networkVisible = !networkVisible;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: networkWindow

            property var modelData
            screen: modelData

            // Only show on the primary/focused screen
            visible: networkVisible && (modelData === Quickshell.screens[0])
            focusable: true

            anchors {
                top: true
                right: true
            }

            margins {
                top: 20
                right: 20
            }

            implicitWidth: 580
            implicitHeight: 920

            color: "transparent"

            NetworkPopup {
                anchors.fill: parent
            }
        }
    }
}
