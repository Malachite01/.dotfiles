import QtQuick
import QtQuick.Layouts

// Generic network-style card: icon button (toggle power) + text info + chevron
//
// WifiCard usage:
//   NetworkCard {
//       colors: colors; fontFamily: root.fontFamily
//       enabled: root.wifiEnabled
//       title: "Wi-Fi"
//       subtitle: root.wifiEnabled ? root.ssid : "désactivé"
//       icon: root.wifiEnabled ? "󰤨" : "󰤭"
//       onCardClicked: Quickshell.execDetached(["bash", "-c", "qs ipc -c network call network toggle"])
//       onIconClicked: { wifiToggle.running = true; Qt.callLater(() => wifiPoller.running = true) }
//   }
//
// BluetoothCard usage:
//   NetworkCard {
//       enabled: root.btEnabled
//       title: "Bluetooth"
//       subtitle: !root.btEnabled ? "désactivé" : root.deviceCount > 0 ? root.connectedName : "aucun appareil connecté"
//       icon: root.btEnabled ? (root.connectedName ? "󰂱" : "󰂯") : "󰂲"
//       onCardClicked: Quickshell.execDetached(["bash", "-c", "qs ipc -c network call network toggle"])
//       onIconClicked: { btToggle.running = true; Qt.callLater(() => btPoller.running = true) }
//   }

Rectangle {
    id: root

    property var colors: ({
        black: "#000000",
        surface1: "#2b2b2b",
        text: "#ffffff",
        overlay2: "#b3b3b3",
        subtext0: "#d0d0d0"
    })
    property string fontFamily: "JetBrainsMono Nerd Font"

    // --- public API ---
    property bool   enabled:  false
    property string title:    ""
    property string subtitle: ""
    property string icon:     ""

    signal cardClicked()
    signal iconClicked()
    signal closeRequested()

    // --- appearance ---
    height: 68
    radius: 25
    transformOrigin: Item.Center

    property bool hovered:    false
    property bool btnHovered: false

    scale: hovered ? 1.02 : 1.0
    color: hovered
        ? Qt.lighter(root.enabled ? colors.black : colors.surface1, 1.3)
        : (root.enabled ? colors.black : colors.surface1)

    Behavior on color { ColorAnimation { duration: 80 } }
    Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

    // background click → card action
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited:  root.hovered = false
        onClicked: root.cardClicked()
        z: -1
    }

    RowLayout {
        anchors { fill: parent; margins: 10 }
        spacing: 12

        // Icon button
        Rectangle {
            width: 48; height: 48
            radius: 15
            color: root.btnHovered
                ? Qt.lighter(root.enabled ? colors.black : colors.surface1, 1.3)
                : (root.enabled ? colors.black : colors.surface1)
            scale: root.btnHovered ? 1.06 : 1.0

            Behavior on color { ColorAnimation { duration: 80 } }
            Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

            Text {
                anchors.centerIn: parent
                text: root.icon
                font.family: root.fontFamily
                font.pixelSize: 22
                color: root.enabled ? colors.text : colors.overlay2
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                z: 1
                onEntered: root.btnHovered = true
                onExited:  root.btnHovered = false
                onClicked: root.iconClicked()
            }
        }

        // Text column
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3

            Text {
                text: root.title
                font.family: root.fontFamily
                font.pixelSize: 13
                font.weight: Font.Bold
                color: colors.text
            }
            Text {
                text: root.subtitle
                font.family: root.fontFamily
                font.pixelSize: 11
                color: colors.subtext0
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Chevron
        Rectangle {
            width: 32; height: 32
            radius: 8
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "\uf105"
                font.family: root.fontFamily
                font.pixelSize: 16
                color: colors.text
            }
        }
    }
}
