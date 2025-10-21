// Workspaces.qml (simplificado)
import Quickshell
import QtQuick

Row {
    id: workspaceDisplay
    spacing: 6

    Repeater {
        model: 5
        Rectangle {
            width: 12; height: 12; radius: 6
            color: (index + 1 === Hyprland.activeWorkspace) ? "#ffffff" : "#555555"
        }
    }
}
