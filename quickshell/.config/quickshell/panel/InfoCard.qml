import QtQuick
import QtQuick.Layouts

// Generic info card — purely display, no interaction.
//
// Half-width example (temp):
//   InfoCard {
//       colors: colors; fontFamily: root.fontFamily
//       half: true
//       icon: "󰔐"; iconColor: levelColor(cpuTemp, 60, 80)
//       title: "Temp"
//       value: cpuTemp + "°C"
//       subvalue: "GPU " + gpuTemp + "°"
//       progress: cpuTemp / 100
//       progressColor: levelColor(cpuTemp, 60, 80)
//   }
//
// Full-width example (storage):
//   InfoCard {
//       colors: colors; fontFamily: root.fontFamily
//       half: false
//       icon: "󰋊"
//       title: "Stockage"
//       value: usedGb + " / " + totalGb + " Go"
//       subvalue: Math.round(ssdUsage * 100) + "% utilisé"
//       progress: ssdUsage
//       progressColor: levelColor(ssdUsage, 0.6, 0.85)
//   }

Rectangle {
    id: root

    required property var    colors
    required property string fontFamily

    // layout
    property bool half: false

    // content
    property string icon:          ""
    property color  iconColor:     colors.text
    property string title:         ""
    property string value:         ""
    property string subvalue:      ""

    // optional arc progress (0.0–1.0, skip arc if < 0)
    property real   progress:      -1
    property color  progressColor: colors.text

    // --- appearance ---
    height: 65
    radius: 25
    color: colors.card_bg_color

    // (arc gauge removed — simplified card)

    // Content
    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        anchors.verticalCenter: parent.verticalCenter

        // Icon + title row (compact when half)
        Row {

            Text {
                text: root.icon
                font.family: root.fontFamily
                font.pixelSize: 16
                color: root.iconColor
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Text {
                text: root.title
                font.family: root.fontFamily
                font.pixelSize: 9
                color: colors.overlay1
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Main value
        Text {
            text: root.value
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.Medium
            color: colors.text
            width: parent.width
        }

        // Sub value (only on full cards)
        Text {
            text: root.subvalue
            font.family: root.fontFamily
            font.pixelSize: 9
            color: colors.overlay0
            width: parent.width
            visible: !root.half && root.subvalue.length > 0
        }
    }
}
