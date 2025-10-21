import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Row {
    id: tray
    spacing: 6

    SystemTray {
        id: systemTray
        anchors.fill: parent
        iconSize: 20
    }
}