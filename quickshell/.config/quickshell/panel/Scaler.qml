import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    visible: false

    property real currentWidth: 1920.0
    property real uiScale: 1.0
    readonly property real densityScale: 0.9

    function getScale(width, scale) {
        return (width / 1920.0) * scale;
    }

    property real baseScale: getScale(currentWidth, uiScale) * densityScale
    
    function s(val) { 
        return Math.round(val * baseScale); 
    }

    Process {
        id: scaleReader
        command: ["bash", "-c", "cat ~/.config/hypr/settings.json 2>/dev/null || echo '{}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    if (this.text && this.text.trim().length > 0 && this.text.trim() !== "{}") {
                        let parsed = JSON.parse(this.text);
                        if (parsed.uiScale !== undefined && root.uiScale !== parsed.uiScale) {
                            root.uiScale = parsed.uiScale;
                        }
                    }
                } catch (e) {}
            }
        }
    }

    // EVENT-DRIVEN WATCHER
    Process {
        id: scaleWatcher
        // -qq keeps it completely silent. It waits for the file to exist, listens for a write, and then exits.
        command: ["bash", "-c", "while [ ! -f ~/.config/hypr/settings.json ]; do sleep 1; done; inotifywait -qq -e modify,close_write ~/.config/hypr/settings.json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                // 1. Read the new data
                scaleReader.running = false;
                scaleReader.running = true;
                // 2. Restart the watcher for the next event
                scaleWatcher.running = false;
                scaleWatcher.running = true;
            }
        }
    }
}
