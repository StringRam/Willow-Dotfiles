import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Column {
    id: tray
    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: iconItem
            required property SystemTrayItem modelData

            width: 20
            height: 20

            Image {
                anchors.fill: parent
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: (e) => {
                    const w = iconItem.QSWindow.window
                    const r = iconItem.QSWindow.itemRect(iconItem) // rect relativo a la ventana

                    if (e.button === Qt.LeftButton) {
                        if (modelData.onlyMenu && modelData.hasMenu)
                            modelData.display(w, r.x - 6, r.y + r.height)   // abre menú
                        else
                            modelData.activate()
                        return
                    }

                    if (e.button === Qt.RightButton) {
                        if (modelData.hasMenu)
                            modelData.display(w, r.x - 6, r.y + r.height)   // menú abajo/izq (ideal barra derecha)
                        else
                            modelData.secondaryActivate()
                        return
                    }

                    if (e.button === Qt.MiddleButton)
                        modelData.secondaryActivate()
                }
            }
        }
    }
}