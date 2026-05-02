import QtQuick
import QtQuick.Layouts

// Reusable slider with a small action button on the right (90% / 10%)
//
// Usage — brightness:
//   PanelSlider {
//       colors: colors; fontFamily: root.fontFamily
//       value: root.brightness
//       icon: root.brightness < 0.3 ? "󰃞" : "󰃠"
//       btnIcon: "󰹑"
//       fillColor: colors.black
//       onMoved: (v) => { root.brightness = v; brightSetter.val = ...; brightSetter.running = true }
//       onReleased: (v) => { brightSetter.val = ...; brightSetter.running = true }
//       onBtnClicked: { /* TODO */ }
//   }
//
// Usage — volume (mute-aware icon, clickable):
//   PanelSlider {
//       value: root.muted ? 0.0 : root.volume
//       fillColor: root.muted ? colors.overlay0 : colors.black
//       icon: root.muted ? "" : (root.volume < 0.5 ? "" : "")
//       iconColor: root.muted ? colors.overlay2 : colors.text
//       iconClickable: true
//       btnIcon: ""
//       onIconClicked: { muteProc.running = true; ... }
//       onMoved: (v) => { root.volume = v }
//       onReleased: (v) => { volSetter.val = v; volSetter.running = true }
//       onBtnClicked: Quickshell.execDetached(["bash", "-c", "pavucontrol &"])
//   }

Item {
    id: root

    required property var    colors
    required property string fontFamily

    // --- public API ---
    property real   value:         0.5
    property string icon:          ""
    property color  iconColor:     colors.text
    property bool   iconClickable: false
    property string btnIcon:       ""
    property color  fillColor:     colors.black

    signal moved(real v)
    signal released(real v)
    signal iconClicked()
    signal btnClicked()

    // --- layout ---
    height: 30

    Row {
        anchors.fill: parent
        spacing: 8

        // ── slider (90%) ──────────────────────────────────────────
        Item {
            id: sliderContainer
            width: parent.width * 0.9
            height: parent.height

            Rectangle {
                anchors.fill: parent
                radius: 14
                color: colors.surface1
                border.color: Qt.rgba(0.06, 0.07, 0.08, 0.01)
                border.width: 4
            }

            Rectangle {
                id: fill
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                width: Math.max(height, sliderContainer.width * root.value)
                radius: 14
                color: root.fillColor
                Behavior on width { NumberAnimation { duration: 80; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation  { duration: 80 } }
            }

            // Icon (optionally clickable)
            Text {
                id: iconText
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 10 }
                text: root.icon
                font.family: root.fontFamily
                font.pixelSize: 16
                color: root.iconColor

                MouseArea {
                    anchors { fill: parent; margins: -10 }
                    enabled: root.iconClickable
                    onClicked: root.iconClicked()
                }
            }

            // Thumb
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                x: Math.min(sliderContainer.width - width,
                   Math.max(0, fill.width - width * 0.5 - 5))
                width:  drag.pressed ? 30 : 12
                height: drag.pressed ? 44 : 44
                radius: 8
                border.color: Qt.rgba(0.06, 0.07, 0.08, 0.89)
                border.width: 3
                color: drag.pressed
                    ? Qt.darker(root.fillColor, 1.2)
                    : Qt.lighter(root.fillColor, 1.3)
                Behavior on width  { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                Behavior on height { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                Behavior on color  { ColorAnimation  { duration: 120 } }
            }

            MouseArea {
                id: drag
                anchors.fill: parent
                preventStealing: true
                onClicked: (mouse) => {
                    let v = Math.max(0, Math.min(1, mouse.x / sliderContainer.width));
                    root.moved(v);
                    root.released(v);
                }
                onPositionChanged: (mouse) => {
                    if (pressed) root.moved(Math.max(0, Math.min(1, mouse.x / sliderContainer.width)));
                }
                onReleased: root.released(Math.max(0, Math.min(1, mouseX / sliderContainer.width)))
            }
        }

        // ── side button (10%) ─────────────────────────────────────
        Rectangle {
            width: parent.width * 0.1
            height: parent.height
            radius: 8
            anchors.verticalCenter: parent.verticalCenter
            color: btnHover.containsMouse ? colors.surface1 : "transparent"
            Behavior on color { ColorAnimation { duration: 80 } }

            Text {
                anchors.centerIn: parent
                text: root.btnIcon
                font.family: root.fontFamily
                font.pixelSize: 16
                color: colors.overlay2
            }

            MouseArea {
                id: btnHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.btnClicked()
            }
        }
    }
}
