import QtQuick
import Quickshell
import Quickshell.Io

NetworkCard {
    id: root

    property string ssid:   "..."
    property string signal: ""

    title:    "Wi-Fi"
    subtitle: root.enabled ? root.ssid : "désactivé"
    icon:     root.enabled ? "󰤨" : "󰤭"

    Process {
        id: wifiPoller
        command: ["bash", "-c",
            "SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); " +
            "PWR=$(nmcli radio wifi); " +
            "SIG=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | grep '^\\*' | cut -d: -f2); " +
            "echo \"$PWR|${SSID:-disconnected}|${SIG:-0}\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split("|");
                root.enabled = (parts[0] === "enabled");
                root.ssid    = parts[1] || "disconnected";
                root.signal  = parts[2] || "0";
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: wifiPoller.running = true
    }

    Process {
        id: wifiToggle
        command: ["bash", "-c", root.enabled ? "nmcli radio wifi off" : "nmcli radio wifi on"]
    }

    onCardClicked: Quickshell.execDetached(["bash", "-c", "qs ipc -c network call network toggle"])
    onIconClicked: {
        wifiToggle.running = true;
        Qt.callLater(() => wifiPoller.running = true);
    }
}
