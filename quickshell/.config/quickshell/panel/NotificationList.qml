import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

// Notification center — drop into Panel.qml ColumnLayout
// Requires NotificationServer instance passed as `server`
//
//   NotificationList {
//       Layout.fillWidth: true
//       colors: colors
//       fontFamily: root.fontFamily
//       server: notifServer   // NotificationServer from shell.qml
//   }

Item {
    id: root

    required property var                colors
    required property string             fontFamily
    required property NotificationServer server

    // dynamic height: header + cards
    height: column.implicitHeight

    Column {
        id: column
        anchors { left: parent.left; right: parent.right }
        spacing: 6

        // ── Header ──────────────────────────────────────────────
        RowLayout {
            width: parent.width
            height: 26

            Text {
                text: "󰂚"
                font.family: root.fontFamily
                font.pixelSize: 13
                color: colors.overlay2
            }
            Text {
                text: "Notifications"
                font.family: root.fontFamily
                font.pixelSize: 11
                color: colors.overlay1
            }
            Text {
                visible: root.server.trackedNotifications.count > 0
                text: root.server.trackedNotifications.count
                font.family: root.fontFamily
                font.pixelSize: 10
                color: colors.overlay0
            }
            Item { Layout.fillWidth: true }
            // Clear all button
            Rectangle {
                visible: root.server.trackedNotifications.count > 0
                width: 22; height: 22
                radius: 6
                color: clearHover.containsMouse ? colors.surface1 : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "󰅗"
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    color: colors.overlay1
                }
                MouseArea {
                    id: clearHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // dismiss all — iterate backwards to avoid index shift
                        for (let i = root.server.trackedNotifications.count - 1; i >= 0; i--) {
                            root.server.trackedNotifications.get(i).dismiss();
                        }
                    }
                }
                Behavior on color { ColorAnimation { duration: 80 } }
            }
        }

        // ── Empty state ──────────────────────────────────────────
        Item {
            visible: root.server.trackedNotifications.count === 0
            width: parent.width
            height: 38

            Text {
                anchors.centerIn: parent
                text: "Aucune notification"
                font.family: root.fontFamily
                font.pixelSize: 11
                color: colors.overlay0
            }
        }

        // ── Notification cards ───────────────────────────────────
        Repeater {
            model: root.server.trackedNotifications

            delegate: NotificationCard {
                required property var modelData
                width: column.width
                colors: root.colors
                fontFamily: root.fontFamily
                notification: modelData
            }
        }
    }
}
