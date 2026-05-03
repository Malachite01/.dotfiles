import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Column {
    id: root
    required property var    colors
    required property string fontFamily
    spacing: 18
    
    signal closeRequested()

    property real volume:     0.55
    property bool muted:      false
    property real brightness: 0.5
    readonly property int maxBrightness: 64764

    // --- Pollers ---
    Process {
        id: volPoller
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let txt = this.text.trim();
                root.muted = txt.includes("[MUTED]");
                let match = txt.match(/Volume:\s*([\d.]+)/);
                if (match) root.volume = Math.min(1.0, parseFloat(match[1]));
            }
        }
    }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: volPoller.running = true }

    Process {
        id: brightPoller
        command: ["bash", "-c", "cat /sys/class/backlight/amdgpu_bl1/brightness"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let val = parseInt(this.text.trim());
                if (!isNaN(val)) root.brightness = val / root.maxBrightness;
            }
        }
    }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: brightPoller.running = true }

    // --- Setters ---
    Process {
        id: volSetter
        property real val: 0
        command: ["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + Math.min(1.0, val).toFixed(2)]
    }
    Process {
        id: brightSetter
        property int val: 0
        command: ["bash", "-c", "brightnessctl set " + val]
    }
    Process {
        id: muteProc
        command: ["bash", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]
    }

    // ── Brightness slider ─────────────────────────────────────────
    PanelSlider {
        width: parent.width
        colors: root.colors
        fontFamily: root.fontFamily

        value:     root.brightness
        icon:      root.brightness < 0.3 ? "󰃞" : "󰃠"
        btnIcon:   "󰹑"
        fillColor: colors.black

        onMoved:   (v) => { root.brightness = v }
        onReleased: (v) => {
            brightSetter.val = Math.round(v * root.maxBrightness);
            brightSetter.running = true;
        }
        onBtnClicked: { /* TODO */ }
    }

    // ── Volume slider ─────────────────────────────────────────────
    PanelSlider {
        width: parent.width
        colors: root.colors
        fontFamily: root.fontFamily

        value:          root.muted ? 0.0 : root.volume
        fillColor:      root.muted ? colors.overlay0 : colors.black
        icon:           root.muted ? "" : (root.volume < 0.5 ? "" : "")
        iconColor:      root.muted ? colors.overlay2 : colors.text
        iconClickable:  true
        btnIcon:        ""

        onIconClicked: {
            muteProc.running = true;
            Qt.callLater(() => volPoller.running = true);
        }
        onMoved:   (v) => { root.volume = v }
        onReleased: (v) => {
            volSetter.val = v;
            volSetter.running = true;
        }
        onBtnClicked: {
            Quickshell.execDetached(["bash", "-c", "pavucontrol &"]);
            root.closeRequested();
        }
    }
}
