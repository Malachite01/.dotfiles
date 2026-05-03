import QtQuick
import Quickshell
import Quickshell.Io

NetworkCard {
    id: root

    property string connectedName: ""
    property int    deviceCount:   0

    title:    "Bluetooth"
    subtitle: !root.enabled
        ? "désactivé"
        : root.deviceCount > 0
            ? (root.connectedName || root.deviceCount + " appareil(s)")
            : "Aucun appareil connecté"
    icon: root.enabled ? (root.connectedName ? "󰂱" : "󰂯") : "󰂲"

    Process {
        id: btPoller
        command: ["bash", "-c",
            "PWR=$(bluetoothctl show 2>/dev/null | grep 'Powered:' | awk '{print $2}'); " +
            "CONN=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-); " +
            "COUNT=$(bluetoothctl devices Connected 2>/dev/null | wc -l); " +
            "echo \"$PWR|${CONN}|$COUNT\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split("|");
                root.enabled       = (parts[0] === "yes");
                root.connectedName = parts[1]?.trim() || "";
                root.deviceCount   = parseInt(parts[2]) || 0;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: btPoller.running = true
    }

    Process {
        id: btToggle
        command: ["bash", "-c", root.enabled ? "bluetoothctl power off" : "bluetoothctl power on"]
    }

    onCardClicked: {
        root.closeRequested();
        Quickshell.execDetached(["bash", "-c", "qs ipc -c network call network showBluetooth"])
    }
    onIconClicked: {
        btToggle.running = true;
        Qt.callLater(() => btPoller.running = true);
    }
}
