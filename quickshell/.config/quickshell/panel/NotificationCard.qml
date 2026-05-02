import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets

Rectangle {
    id: root

    required property var          colors
    required property string       fontFamily
    required property Notification notification

    readonly property bool isCritical: notification.urgency === NotificationUrgency.Critical
    readonly property bool isLow:      notification.urgency === NotificationUrgency.Low

    height: cardColumn.implicitHeight + 20
    radius: 16

    color: isCritical
        ? Qt.rgba(0.23, 0.08, 0.07, 0.95)
        : colors.surface0

    border.color: isCritical
        ? Qt.rgba(0.98, 0.29, 0.20, 0.45)
        : Qt.rgba(1, 1, 1, 0.04)
    border.width: 1

    // slide-in animation on appear
    opacity: 0
    Component.onCompleted: opacity = 1
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    // hover dim
    property bool hovered: false
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited:  root.hovered = false
        z: -1
    }

    Column {
        id: cardColumn
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
        spacing: 6

        // ── Top row: icon + app name + time + close ──────────────
        RowLayout {
            width: parent.width
            height: 22
            spacing: 6

            // App icon (if available)
            IconImage {
                visible: notification.appIcon !== ""
                source:  notification.appIcon
                width:   16; height: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: notification.appName || "App"
                font.family: root.fontFamily
                font.pixelSize: 10
                color: root.isCritical ? "#fb4934" : colors.overlay1
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            // urgency dot
            Rectangle {
                visible: root.isCritical
                width: 6; height: 6; radius: 3
                color: "#fb4934"
                anchors.verticalCenter: parent.verticalCenter
            }

            // Close button (visible on hover)
            Rectangle {
                visible: root.hovered || root.isCritical
                width: 20; height: 20; radius: 6
                color: closeArea.containsMouse ? colors.surface1 : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "󰅖"
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    color: colors.overlay2
                }
                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.notification.dismiss()
                }
                Behavior on color { ColorAnimation { duration: 60 } }
            }
        }

        // ── Summary ──────────────────────────────────────────────
        Text {
            visible: notification.summary !== ""
            width: parent.width
            text: notification.summary
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.Medium
            color: colors.text
            elide: Text.ElideRight
            textFormat: Text.PlainText
        }

        // ── Body ─────────────────────────────────────────────────
        Text {
            visible: notification.body !== ""
            width: parent.width
            text: notification.body
            font.family: root.fontFamily
            font.pixelSize: 11
            color: colors.subtext0
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            elide: Text.ElideRight
            textFormat: Text.PlainText
        }

        // ── Actions ──────────────────────────────────────────────
        Row {
            visible: notification.actions.length > 0
            spacing: 6
            width: parent.width
            topPadding: 2

            Repeater {
                model: notification.actions

                delegate: Rectangle {
                    required property var modelData
                    height: 24
                    width:  Math.min(actionLabel.implicitWidth + 20, 120)
                    radius: 8
                    color: actionHover.containsMouse
                        ? colors.surface2
                        : colors.surface1

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: modelData.text || modelData.identifier
                        font.family: root.fontFamily
                        font.pixelSize: 10
                        color: colors.subtext0
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: actionHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: modelData.invoke()
                    }
                    Behavior on color { ColorAnimation { duration: 60 } }
                }
            }
        }
    }
}
