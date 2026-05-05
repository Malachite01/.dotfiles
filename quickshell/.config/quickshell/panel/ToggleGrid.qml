import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    required property var    colors
    required property string fontFamily
    height: 155

    // keyFocusIndex : 0=vpn, 1=perf, 2=caffeine, 3=nuit
    property int keyFocusIndex: -1

    property int  perfProfile: 1
    property bool idleOff:     false
    property bool nightOn:     false
    property bool vpnOn:       false

    function toggleVpn()      { root.vpnOn  = !root.vpnOn;  vpnProc.running  = true }
    function cyclePerfm()     {
        root.perfProfile = (root.perfProfile + 1) % root.perfProfiles.length;
        perfProc.profile = root.tunedProfiles[root.perfProfile];
        perfProc.running = true;
    }
    function toggleCaffeine() { root.idleOff = !root.idleOff; idleProc.running = true }
    function toggleNight()    { root.nightOn = !root.nightOn; nightProc.running = true }

    readonly property var perfProfiles: [
        { icon: "󰌪", sublabel: "Economie",    color: "#8ec07c" },
        { icon: "",  sublabel: "Equilibre",   color: "#83a598" },
        { icon: "",  sublabel: "Bureau",   color: '#fabd2f' },
        { icon: "",  sublabel: "Boost", color: "#fb4934" }
    ]

    readonly property var tunedProfiles: [
        "laptop-battery-powersave",
        "balanced-battery",
        "desktop",
        "throughput-performance"
    ]

    Process { id: idleProc; command: ["bash", "/home/pandora/.config/hypr/scripts/idle_inhibitor.sh"] }
    Process { id: nightProc; command: ["bash", "/home/pandora/.config/hypr/scripts/night.sh"] }
    Process { id: vpnProc;  command: ["bash", "-c", "echo 'TODO: toggle vpn'"] }
    Process {
        id: perfProc
        property string profile: ""
        command: ["bash", "/home/pandora/.config/hypr/scripts/battery/battery-switch.sh", profile]
    }

    // Lecture profil actif au démarrage
    Process {
        id: perfStateCheck
        command: ["bash", "-c", "tuned-adm active | awk '{print $NF}'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let idx = root.tunedProfiles.indexOf(data.trim())
                if (idx !== -1) root.perfProfile = idx
            }
        }
    }

    // Resync si udev a changé le profil (plug/unplug)
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: perfStateCheck.running = true
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
            keyFocused: root.keyFocusIndex === 0
            onToggled: root.toggleVpn()
        }

        CycleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            label:        "Performance"
            currentIndex: root.perfProfile
            cycleStates:  root.perfProfiles
            keyFocused: root.keyFocusIndex === 1
            onCycled: (idx) => {
                root.perfProfile = idx
                perfProc.profile = root.tunedProfiles[idx]
                perfProc.running = true
            }
        }

        ToggleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            active:   root.idleOff
            icon:     root.idleOff ? "󰅶" : "󰾪"
            label:    "Caffeine"
            sublabel: root.idleOff ? "on" : "off"
            keyFocused: root.keyFocusIndex === 2
            onToggled: root.toggleCaffeine()
        }

        ToggleButton {
            Layout.fillWidth: true
            colors: root.colors
            fontFamily: root.fontFamily
            active:   root.nightOn
            icon:     root.nightOn ? "󱠨" : ""
            label:    "Nuit"
            sublabel: root.nightOn ? "on" : "off"
            keyFocused: root.keyFocusIndex === 3
            onToggled: root.toggleNight()
        }
    }
}
