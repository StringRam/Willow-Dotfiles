// Tray.qml — Compatible con Quickshell v0.2.1
import Quickshell
import QtQuick
import QtQuick.Layouts

Row {
    id: tray
    spacing: 6

    // El servicio de SystemTray expone una lista de íconos activos
    Repeater {
        id: trayRepeater
        model: (Quickshell.Services && Quickshell.Services.systemTray)
            ? Quickshell.Services.systemTray.items
            : []

        delegate: Image {
            width: 20
            height: 20
            source: modelData.icon
            fillMode: Image.PreserveAspectFit

            MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                modelData.activate()
            else if (mouse.button === Qt.RightButton)
                modelData.secondaryActivate()
            }
            }

        }
    }
}
