import QtQuick
import QtQuick.Layouts

// Multi-state cycle button (click → advance to next state)
// Usage:
//   CycleButton {
//       colors: colors; fontFamily: root.fontFamily
//       label: "Performance"
//       currentIndex: root.perfProfile
//       states: [
//           { icon: "󰌪", sublabel: "Economie",    color: "#8ec07c" },
//           { icon: "",  sublabel: "Equilibre",   color: "#83a598" },
//           { icon: "",  sublabel: "Performance", color: "#fb4934" }
//       ]
//       onCycled: (newIndex) => { root.perfProfile = newIndex; ... }
//   }

Rectangle {
    id: root

    required property var    colors
    required property string fontFamily

    // --- public API ---
    property string label:        ""
    property int    currentIndex: 0
    property var    cycleStates:  []   // array of { icon, sublabel, color }
    property bool   keyFocused:   false   // ← focus clavier

    signal cycled(int newIndex)

    // --- convenience ---
    readonly property var currentState: cycleStates.length > 0
        ? cycleStates[currentIndex]
        : { icon: "", sublabel: "", color: "#ffffff" }

    // --- appearance ---
    height: 65
    radius: 25
    transformOrigin: Item.Center
    scale: (area.containsMouse || keyFocused) ? 1.02 : 1.0
    color: colors.black

    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Text {
            text: root.currentState.icon
            font.family: root.fontFamily
            font.pixelSize: 24
            color: root.currentState.color
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 80 } }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: root.label
                font.family: root.fontFamily
                font.pixelSize: 11
                color: colors.subtext0
            }

            Text {
                text: root.currentState.sublabel
                font.family: root.fontFamily
                font.pixelSize: 10
                color: root.currentState.color
                Behavior on color { ColorAnimation { duration: 80 } }
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            let next = (root.currentIndex + 1) % root.cycleStates.length;
            root.cycled(next);
        }
    }
}
