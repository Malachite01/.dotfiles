import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    id: root
    signal closeRequested()

    // Size panel from laid out content to avoid item overlap.
    implicitHeight: content.implicitHeight + 28

    FontLoader {
        id: jetbrainsMonoFont
        source: "JetBrainsMonoNerdFont-Regular.ttf"
    }

    readonly property string fontFamily: (jetbrainsMonoFont.status === FontLoader.Ready && jetbrainsMonoFont.name && jetbrainsMonoFont.name.trim().length > 0)
        ? jetbrainsMonoFont.name
        : "JetBrainsMono NF"

    MatugenColors { id: colors }

    // ── Navigation clavier ────────────────────────────────────────
    // Ordre : 0=wifi, 1=bt, 2=vpn, 3=perf, 4=caffeine, 5=nuit
    property int focusIndex: -1
    readonly property int focusMax: 5

    function focusNext() { focusIndex = (focusIndex + 1) % (focusMax + 1) }
    function focusPrev() { focusIndex = (focusIndex - 1 + focusMax + 1) % (focusMax + 1) }
    function activateFocused() {
        if      (focusIndex === 0) wifiCard.activate()
        else if (focusIndex === 1) btCard.activate()
        else if (focusIndex === 2) toggleGrid.toggleVpn()
        else if (focusIndex === 3) toggleGrid.cyclePerfm()
        else if (focusIndex === 4) toggleGrid.toggleCaffeine()
        else if (focusIndex === 5) toggleGrid.toggleNight()
    }

    Keys.onDownPressed:   focusNext()
    Keys.onUpPressed:     focusPrev()
    Keys.onTabPressed:    focusNext()
    Keys.onBacktabPressed: focusPrev()
    Keys.onReturnPressed: activateFocused()
    Keys.onEnterPressed:  activateFocused()
    Keys.onEscapePressed: { focusIndex = -1; root.closeRequested() }

    MouseArea {
        anchors.fill: parent
        onClicked: {}
        propagateComposedEvents: true
        onPressed: (mouse) => mouse.accepted = false
    }

    Rectangle {
        id: panelBg
        anchors.fill: parent
        color: Qt.rgba(0.06, 0.07, 0.08, 0.9)
        radius: 16

        ColumnLayout {
            id: content
            anchors {
                fill: parent
                margins: 14
            }
            spacing: 5

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "  " 
                    font.family: root.fontFamily
                    font.pixelSize: 15
                    color: colors.text
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 28; height: 28
                    radius: 8
                    color: closeHover.containsMouse ? colors.surface1 : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        font.family: root.fontFamily
                        font.pixelSize: 16
                        color: colors.overlay1
                    }
                    MouseArea {
                        id: closeHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.closeRequested()
                    }
                    Behavior on color { ColorAnimation { duration: 80 } }
                }
            }
            
            WifiCard {
                id: wifiCard
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
                keyFocused: root.focusIndex === 0
            }

            BluetoothCard {
                id: btCard
                Layout.bottomMargin: 2
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
                keyFocused: root.focusIndex === 1
            }

            SystemInfoRow {
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
            }

            ToggleGrid {
                id: toggleGrid
                Layout.topMargin: -6
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                keyFocusIndex: root.focusIndex - 2
            }


            SliderRow {
                Layout.topMargin: 15
                Layout.bottomMargin: 5
                Layout.fillWidth: true
                colors: colors
                fontFamily: root.fontFamily
                onCloseRequested: root.closeRequested()
            }

        }
    }

}
