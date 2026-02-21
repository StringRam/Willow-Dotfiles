import Quickshell
import QtQuick

Column {
    id: tray
    spacing: 8

    Repeater {
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
                    if (mouse.button === Qt.LeftButton) modelData.activate()
                    else if (mouse.button === Qt.RightButton) modelData.secondaryActivate()
                }
            }
        }
    }
}