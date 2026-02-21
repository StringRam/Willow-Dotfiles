import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    spacing: 8

    // 1..5 en kanji
    readonly property var labels: ["一", "二", "三", "四", "五"]

    Repeater {
        model: 5

        Rectangle {
            id: chip
            Layout.alignment: Qt.AlignHCenter

            // tamaño “botón” (ajustá a tu barra)
            width: 28
            height: 28
            radius: 8

            property int wsId: index + 1
            property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
            property bool isActive: Hyprland.focusedWorkspace?.id === wsId
            property bool exists: ws !== undefined && ws !== null
            property bool hovered: area.containsMouse

            // Fondo según estado
            color: isActive
                ? "#707C4F"
                : (hovered ? "#2a2a2a" : (exists ? "#1f1f1f" : "transparent"))

            // Borde sutil (más visible cuando existe)
            border.width: isActive ? 0 : 1
            border.color: exists ? "#3a3a3a" : "#232323"

            Text {
                anchors.centerIn: parent
                text: root.labels[index]   // <-- kanji
                color: isActive ? "#0b0b0b" : (exists ? "#d0d0d0" : "#4a4a4a")
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Hyprland.dispatch("workspace " + chip.wsId)
            }
        }
    }
}