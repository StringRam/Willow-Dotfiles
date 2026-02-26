import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "."

Column {
  id: tray
  spacing: 8
  required property PanelWindow parentWindow

  TrayMenuPopup { id: menuPopup }

  function clamp(v, lo, hi) { return Math.max(lo, Math.min(v, hi)) }

  function openMenuFor(iconItem, trayItem) {
    if (!trayItem.hasMenu || !trayItem.menu) return
    if (!tray.parentWindow) return

    // 1) Asegurar que el popup salga en el mismo monitor que la barra
    menuPopup.targetScreen = tray.parentWindow.screen

    const screenW = tray.parentWindow.screen?.width ?? 1920
    const screenH = tray.parentWindow.screen?.height ?? 1080

    // 2) Barra anclada a la derecha => borde izquierdo del bar en coords de screen
    const barW = tray.parentWindow.width
    const barLeft = screenW - barW
    const gap = 4

    // 3) Posición REAL del icono dentro de la barra:
    // mapear el ícono al contentItem del PanelWindow (coords “bar-local”)
    const p = iconItem.mapToItem(tray.parentWindow.contentItem, 0, 0)

    // Como la barra está top-to-bottom, el Y local ya es el Y real dentro del screen
    const iconGlobalY = p.y

    // 4) Tamaño del menú (coincidir con TrayMenuPopup)
    const menuW = 360
    const rowH = 34
    const pad = 8
    const count = Math.max(1, menuPopup.menuCount)
    const menuH = count * rowH + pad * 2 + 6

    menuPopup.menuWidth = menuW

    // X fijo pegado al bar (hacia la izquierda)
    let x = barLeft - gap - menuW
    x = clamp(x, 4, screenW - menuW - 4)

    // Y centrado en el ícono y clamped
    let y = iconGlobalY - 6; // el menú “nace” alineado al ícono
    y = clamp(y, 4, screenH - menuH - 4);

    menuPopup.anchorX = Math.round(x)
    menuPopup.anchorY = Math.round(y)
    menuPopup.menuHandle = trayItem.menu
  }

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: iconItem
      required property SystemTrayItem modelData
      width: 20
      height: 20

      Image { anchors.fill: parent; source: modelData.icon; fillMode: Image.PreserveAspectFit }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onPressed: (e) => {
          if (e.button === Qt.RightButton) {
            tray.openMenuFor(iconItem, modelData)
            e.accepted = true
            return
          }
          if (e.button === Qt.MiddleButton) {
            modelData.secondaryActivate()
            e.accepted = true
          }
        }

        onClicked: (e) => {
          if (e.button !== Qt.LeftButton) return
          if (modelData.onlyMenu && modelData.hasMenu) tray.openMenuFor(iconItem, modelData)
          else modelData.activate()
        }
      }
    }
  }
}