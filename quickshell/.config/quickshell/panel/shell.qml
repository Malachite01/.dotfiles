//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    id: root

    property bool panelVisible: false

    IpcHandler {
        target: "panel"
        function toggle(): void {
            root.panelVisible = !root.panelVisible;
        }
        function show(): void {
            root.panelVisible = true;
        }
        function hide(): void {
            root.panelVisible = false;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            property var modelData
            screen: modelData

            WlrLayershell.namespace: "quickshell:panel"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore

            // Only on focused/primary screen
            visible: root.panelVisible && (modelData === Quickshell.screens[0])

            anchors {
                top: true
                right: true
            }

            margins { 
                top: 30; 
                right: 6; 
            }
  

            implicitWidth: Math.round(screen.width / 4.3)
            implicitHeight: panel.implicitHeight

            color: "transparent"
            focusable: true

                Panel {
                id: panel
                anchors.fill: parent

                focus: true
                Keys.onEscapePressed: root.panelVisible = false
                onCloseRequested: root.panelVisible = false
            }
        }
    }
}
