import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "."

Column {
  id: tray
  spacing: 8

  required property PanelWindow parentWindow  // lo pasás desde Bar.qml

  TrayMenuPopup {
    id: menuPopup
    parentWindow: tray.parentWindow
  }

  function openMenuFor(iconItem, trayItem) {
    if (!trayItem.hasMenu || !trayItem.menu) return

    // coordenadas del ícono dentro del contentItem de la barra
    const p = iconItem.mapToItem(tray.parentWindow.contentItem, 0, iconItem.height)

    menuPopup.maxWidth = 260
    menuPopup.anchorX = p.x - 260 - 12   // barra derecha → menú hacia la izquierda
    menuPopup.anchorY = p.y
    menuPopup.menuHandle = trayItem.menu
  }

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
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onPressed: (e) => {
          if (e.button === Qt.RightButton) {
            tray.openMenuFor(iconItem, modelData)
            e.accepted = true
          } else if (e.button === Qt.MiddleButton) {
            modelData.secondaryActivate()
            e.accepted = true
          }
        }

        onClicked: (e) => {
          if (e.button !== Qt.LeftButton) return

          if (modelData.onlyMenu && modelData.hasMenu) {
            tray.openMenuFor(iconItem, modelData)
          } else {
            modelData.activate()
          }
        }
      }
    }
  }
}