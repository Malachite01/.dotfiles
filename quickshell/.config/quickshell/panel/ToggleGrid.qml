import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    required property var    colors
    required property string fontFamily
    height: 155

    property int  perfProfile: 1
    property bool idleOff:     false
    property bool nightOn:     false
    property bool vpnOn:       false

    readonly property var perfProfiles: [
        { icon: "󰌪", sublabel: "Economie",    color: "#8ec07c" },
        { icon: "",  sublabel: "Equilibre",   color: "#83a598" },
        { icon: "",  sublabel: "Boost", color: "#fb4934" }
    ]

    Process { id: idleProc; command: ["bash", "-c", "echo 'TODO: toggle idle'"] }
    Process { id: nightProc; command: ["bash", "-c", "echo 'TODO: toggle night mode'"] }
    Process { id: vpnProc;  command: ["bash", "-c", "echo 'TODO: toggle vpn'"] }

    Process {
        id: perfProc
        property string profile: ""
        command: ["bash", "-c", "echo 'TODO: set profile " + profile + "'"]
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        rowSpacing: -10
        columnSpacing: 10

        ToggleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            active:   root.vpnOn
            icon:     root.vpnOn ? "󰯄" : "󱦃"
            label:    "VPN"
            sublabel: root.vpnOn ? "on" : "off"
            onToggled: {
                root.vpnOn = !root.vpnOn;
                vpnProc.running = true;
            }
        }

        CycleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            label:        "Performance"
            currentIndex: root.perfProfile
            cycleStates:  root.perfProfiles
            onCycled: (idx) => {
                root.perfProfile = idx;
                perfProc.profile = ["powersave", "balanced", "performance"][idx];
                perfProc.running = true;
            }
        }

        ToggleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            active:   root.idleOff
            icon:     root.idleOff ? "󰈈" : "󰈉"
            label:    "Veille"
            sublabel: root.idleOff ? "off" : "on"
            onToggled: {
                root.idleOff = !root.idleOff;
                idleProc.running = true;
            }
        }

        ToggleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            active:   root.nightOn
            icon:     root.nightOn ? "󱠨" : ""
            label:    "Nuit"
            sublabel: root.nightOn ? "on" : "off"
            onToggled: {
                root.nightOn = !root.nightOn;
                nightProc.running = true;
            }
        }
    }
}
