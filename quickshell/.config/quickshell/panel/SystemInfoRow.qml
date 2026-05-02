import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// One row: [½ Temp][½ RAM][1 Stockage]
// Drop-in in Panel.qml:
//   SystemInfoRow { Layout.fillWidth: true; colors: colors; fontFamily: root.fontFamily }

Item {
    id: root
    required property var    colors
    required property string fontFamily

    height: 65

    // ── state ────────────────────────────────────────────────────
    property real cpuTemp:   0      // °C
    property real gpuTemp:   0      // °C
    property real ramUsage:  0.0    // 0–1
    property real ramUsedGb: 0.0
    property real ramTotalGb: 0.0
    property real ssdUsage:  0.0    // 0–1
    property real ssdUsedGb: 0.0
    property real ssdTotalGb: 0.0

    // ── color helpers ────────────────────────────────────────────
    function usageColor(v) {
        if (v > 0.85) return "#fb4934";
        if (v > 0.60) return "#fabd2f";
        return "#8ec07c";
    }
    function tempColor(t) {
        if (t > 80) return "#fb4934";
        if (t > 60) return "#fabd2f";
        return "#8ec07c";
    }

    // ── pollers ──────────────────────────────────────────────────
    Process {
        id: tempPoller
        command: ["bash", "-c",
            "CPU=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0); " +
            "GPU=$(cat /sys/class/drm/card0/device/hwmon/hwmon1/temp1_input 2>/dev/null " +
            "      || cat /sys/class/hwmon/hwmon0/temp1_input 2>/dev/null || echo 0); " +
            "echo \"$((CPU/1000))|$((GPU/1000))\""
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let p = this.text.trim().split("|");
                root.cpuTemp = parseInt(p[0]) || 0;
                root.gpuTemp = parseInt(p[1]) || 0;
            }
        }
    }

    Process {
        id: ramPoller
        command: ["bash", "-c",
            "free -m | awk '/^Mem:/{printf \"%d|%d\", $3, $2}'"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let p = this.text.trim().split("|");
                let used  = parseInt(p[0]) || 0;
                let total = parseInt(p[1]) || 1;
                root.ramUsedGb  = (used  / 1024).toFixed(1);
                root.ramTotalGb = (total / 1024).toFixed(1);
                root.ramUsage   = Math.min(1, used / total);
            }
        }
    }

    Process {
        id: ssdPoller
        command: ["bash", "-c",
            "df -BG / | awk 'NR==2{gsub(\"G\",\"\",$3); gsub(\"G\",\"\",$2); " +
            "printf \"%s|%s\", $3, $2}'"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let p = this.text.trim().split("|");
                let used  = parseInt(p[0]) || 0;
                let total = parseInt(p[1]) || 1;
                root.ssdUsedGb  = used;
                root.ssdTotalGb = total;
                root.ssdUsage   = Math.min(1, used / total);
            }
        }
    }

    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered: {
            tempPoller.running = true;
            ramPoller.running  = true;
            ssdPoller.running  = true;
        }
    }

    // ── layout ───────────────────────────────────────────────────
    RowLayout {
        anchors.fill: parent
        spacing: 9

        // ½ — Température
        InfoCard {
            Layout.preferredWidth: parent.width * 0.23
            colors:     root.colors
            fontFamily: root.fontFamily
            half:       true
            icon:       "󰔐"
            iconColor:  root.tempColor(root.cpuTemp)
            value:      root.cpuTemp + "°C"
            subvalue:   root.gpuTemp > 0 ? "GPU " + root.gpuTemp + "°" : ""
            progress:   root.cpuTemp / 100
            progressColor: root.tempColor(root.cpuTemp)
        }

        // ½ — RAM
        InfoCard {
            Layout.preferredWidth: parent.width * 0.23
            colors:     root.colors
            fontFamily: root.fontFamily
            half:       true
            icon:       "󰍛"
            iconColor:  root.usageColor(root.ramUsage)
            value:      root.ramUsedGb + " Go"
            subvalue:   "/ " + root.ramTotalGb + " Go"
            progress:   root.ramUsage
            progressColor: root.usageColor(root.ramUsage)
        }

        // 1 — Stockage (double width)
        InfoCard {
            Layout.preferredWidth: parent.width * 0.48   // takes ~half the row = full card width
            colors:     root.colors
            fontFamily: root.fontFamily
            half:       false
            icon:       "󰋊"
            iconColor:  root.usageColor(root.ssdUsage)
            value:      root.ssdUsedGb + " / " + root.ssdTotalGb + " Go"
            progress:   root.ssdUsage
            progressColor: root.usageColor(root.ssdUsage)
        }
    }
}
