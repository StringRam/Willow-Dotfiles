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

    menuPopup.targetScreen = tray.parentWindow.screen

    const screenW = tray.parentWindow.screen?.width ?? 1920
    const screenH = tray.parentWindow.screen?.height ?? 1080
    const barW = tray.parentWindow.width

    // Barra anclada a la derecha (en ese screen)
    const barLeft = screenW - barW
    const barTop = 0

    // 1) Posición del bloque SystemTray dentro de la barra (en coords "window/item tree")
    // (tray es el Column root de SystemTray.qml)
    const trayPosInBar = tray.mapToItem(tray.parentWindow.contentItem, 0, 0)

    // 2) Posición del ícono dentro de tray
    // iconItem está dentro del Repeater delegado, su y es relativa a tray
    const iconYInTray = iconItem.y

    // 3) Y global del ícono (screen coords)
    const iconGlobalY = barTop + trayPosInBar.y + iconYInTray

    // Menú a la izquierda de la barra con gap fijo
    const gap = 4
    const menuW = 360
    const rowH = 34
    const pad = 8
    const estCount = 18
    const menuH = estCount * rowH + pad * 2

    menuPopup.menuWidth = menuW

    // X fijo pegado a la barra
    let x = barLeft - gap - menuW
    x = clamp(x, 4, screenW - menuW - 4)

    // Y centrado en el ícono y clamp
    let y = (iconGlobalY + iconItem.height / 2) - (menuH / 2)
    y = clamp(y, 4, screenH - menuH - 4)

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