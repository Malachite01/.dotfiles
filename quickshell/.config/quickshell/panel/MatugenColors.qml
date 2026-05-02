import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property color base:     "#282828"
    property color mantle:   "#1d2021"
    property color crust:    "#141617"
    property color text:     "#ebdbb2"
    property color subtext0: "#d5c4a1"
    property color subtext1: "#bdae93"
    property color card_bg_color: "#3c3836"
    property color surface1: "#504945"
    property color surface2: "#665c54"
    property color overlay0: "#7c6f64"
    property color overlay1: "#928374"
    property color overlay2: "#a89984"
    property color black:    "#32302f"
    property color blue:     "#83a598"
    property color sapphire: "#76a5af"
    property color peach:    "#fe8019"
    property color green:    "#b8bb26"
    property color red:      "#fb4934"
    property color mauve:    "#d3869b"
    property color pink:     "#d3869b"
    property color yellow:   "#fabd2f"
    property color maroon:   "#cc241d"
    property color teal:     "#8ec07c"

    property string rawJson: ""

    Process {
        id: themeReader
        command: ["cat", Quickshell.env("HOME") + "/.config/quickshell/panel/qs_colors.json"]
        stdout: StdioCollector {
            onStreamFinished: {
                let txt = this.text.trim();
                if (txt !== "" && txt !== root.rawJson) {
                    root.rawJson = txt;
                    try {
                        let c = JSON.parse(txt);
                        if (c.base)     root.base     = c.base;
                        if (c.mantle)   root.mantle   = c.mantle;
                        if (c.crust)    root.crust    = c.crust;
                        if (c.text)     root.text     = c.text;
                        if (c.subtext0) root.subtext0 = c.subtext0;
                        if (c.subtext1) root.subtext1 = c.subtext1;
                        if (c.card_bg_color) root.card_bg_color = c.card_bg_color;
                        if (c.surface1) root.surface1 = c.surface1;
                        if (c.surface2) root.surface2 = c.surface2;
                        if (c.overlay0) root.overlay0 = c.overlay0;
                        if (c.overlay1) root.overlay1 = c.overlay1;
                        if (c.overlay2) root.overlay2 = c.overlay2;
                        if (c.black)     root.black     = c.black;
                        if (c.sapphire) root.sapphire = c.sapphire;
                        if (c.peach)    root.peach    = c.peach;
                        if (c.green)    root.green    = c.green;
                        if (c.red)      root.red      = c.red;
                        if (c.mauve)    root.mauve    = c.mauve;
                        if (c.pink)     root.pink     = c.pink;
                        if (c.yellow)   root.yellow   = c.yellow;
                        if (c.maroon)   root.maroon   = c.maroon;
                        if (c.teal)     root.teal     = c.teal;
                    } catch(e) {}
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: themeReader.running = true
    }
}
