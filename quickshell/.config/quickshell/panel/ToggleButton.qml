import QtQuick
import QtQuick.Layouts

// Generic on/off toggle button
// Usage:
//   ToggleButton {
//       colors: colors; fontFamily: root.fontFamily
//       icon: active ? "󰈈" : "󰈉"
//       label: "Veille"
//       sublabel: active ? "off" : "on"
//       active: root.idleOff
//       onToggled: { root.idleOff = !root.idleOff; idleProc.running = true }
//   }

Rectangle {
    id: root

    required property var    colors
    required property string fontFamily

    // --- public API ---
    property bool   active:   false
    property string icon:     ""
    property string label:    ""
    property string sublabel: ""
    property bool   keyFocused: false   // ← focus clavier

    signal toggled()

    // --- appearance ---
    height: 65
    radius: 25
    transformOrigin: Item.Center

    scale: (area.containsMouse || keyFocused) ? 1.02 : 1.0
    color: (area.containsMouse || keyFocused)
        ? Qt.lighter(root.active ? colors.black : colors.surface1, 1.3)
        : (root.active ? colors.black : colors.surface1)

    Behavior on color { ColorAnimation { duration: 80 } }
    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Text {
            text: root.icon
            font.family: root.fontFamily
            font.pixelSize: 24
            color: root.active ? colors.text : colors.overlay2
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: root.label
                font.family: root.fontFamily
                font.pixelSize: 11
                color: root.active ? colors.text : colors.subtext0
            }

            Text {
                text: root.sublabel
                font.family: root.fontFamily
                font.pixelSize: 10
                color: root.active ? colors.subtext1 : colors.overlay0
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.toggled()
    }
}
