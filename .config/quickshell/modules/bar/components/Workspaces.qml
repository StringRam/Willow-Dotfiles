// Workspaces.qml — Quickshell v0.2.1 (con verificación segura)
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 8

    Repeater {
        model: 9

        Text {
            //Live data coming from Hyprland
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            text: index + 1
            color: isActive? "#707C4F" : (ws ? "#6b6b6b" : "#3a3a3a")
            font {pixelSize: 14; bold: true}

            // Click to switch workspace
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
