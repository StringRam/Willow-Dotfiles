// Workspaces.qml — Quickshell v0.2.1 (con verificación segura)
import Quickshell
import Quickshell.Hyprland
import QtQuick

Row {
    id: workspaceDisplay
    spacing: 6
    property int count: 5

    // Verificamos que el servicio esté disponible antes de usarlo
    readonly property var hypr: Quickshell.Services ? Quickshell.Services.hyprland : null

    Repeater {
        id: wsRepeater
        model: hypr ? hypr.workspaces : []

        delegate: Rectangle {
            width: 12
            height: 12
            radius: 6

            color: hypr && (modelData.id === hypr.activeWorkspace.id)
                ? "#ffffff"
                : "#555555"

            visible: index < workspaceDisplay.count

            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                onClicked: if (hypr) hypr.dispatch(`workspace ${modelData.id}`)
            }
        }
    }
}
