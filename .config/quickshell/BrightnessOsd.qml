// BrightnessOsd.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 120
    color: "transparent"

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region {
        item: root.showing ? flyout : null
    }

    // -------------------------
    // Backlight device resolution
    // -------------------------

    property string backlightDevice: ""
    property int maxBrightness: 1
    property int rawBrightness: 0

    property real brightness: maxBrightness > 0
        ? rawBrightness / maxBrightness
        : 0

    Process {
        id: findDevice
        command: ["sh", "-c", "ls /sys/class/backlight | head -1"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.backlightDevice = data.trim()
            }
        } 
    }

    FileView {
        id: maxFile
        path: root.backlightDevice
            ? "/sys/class/backlight/" + root.backlightDevice + "/max_brightness"
            : ""

        onLoaded: {
            root.maxBrightness = parseInt(text().trim())
        }
    }

    FileView {
        id: brightnessFile
        path: root.backlightDevice
            ? "/sys/class/backlight/" + root.backlightDevice + "/brightness"
            : ""

        watchChanges: true

        onLoaded: {
            root.rawBrightness = parseInt(text().trim())
        }

        onFileChanged: {
            reload()
            root.showOsd()
        }
    }

    // -------------------------
    // OSD state
    // -------------------------

    property bool showing: false

    function showOsd() {
        showing = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1200
        repeat: false
        onTriggered: root.showing = false
    }

    // -------------------------
    // OSD
    // -------------------------

    Rectangle {
        id: flyout

        width: 320
        height: 28

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30

        radius: 36
        color: "#80000000"

        opacity: root.showing ? 1 : 0
        scale: root.showing ? 1 : 0.9

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        Text {
            id: icon

            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            text: {
                if (root.brightness <= 0)
                    return "󰃞"
                if (root.brightness < 0.5)
                    return "󰃟"
                return "󰃠"
            }

            font.family: "Symbols Nerd Font"
            font.pixelSize: 16
            color: "white"
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            text: Math.round(root.brightness * 100) + "%"

            font.pixelSize: 12
            font.bold: true
            color: "white"
        }

        Rectangle {
            anchors.left: icon.right
            anchors.leftMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 68
            anchors.verticalCenter: parent.verticalCenter

            height: 5
            radius: 4
            color: "#555555"

            Rectangle {
                width: parent.width * Math.min(root.brightness, 1)
                height: parent.height
                radius: 4
                color: "white"

                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
}