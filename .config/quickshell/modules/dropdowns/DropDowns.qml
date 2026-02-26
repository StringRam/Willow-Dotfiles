import QtQuick
import qs.services
import "modules/dropdowns"
import "../notifs/NotifContent.qml" as NotifsUI
import "../dashboard/DashboardContent.qml" as DashUI

Item {
  id: root
  // AnchorPanel te pasa su PanelWindow
  required property var anchorWindow

  // === NOTIFS drawer (esquina izquierda) ===
  Drawer {
    id: notifsDrawer
    anchorWindow: root.anchorWindow
    open: Visibility.notifsOpen

    width: 360
    height: 520

    // sale desde esquina izq, por debajo del panel
    anchorX: 12
    anchorY: root.anchorWindow.height + 8

    // mantener abierto por hover (si ya tenés esos flags en Visibility)
    onHoveredChanged: {
      Visibility.notifsPanelHovered = hovered
      Visibility.refreshNotifsHoverHold()
    }

    NotifsUI.NotifContent { anchors.fill: parent }
  }

  // === DASHBOARD drawer (centro) ===
  Drawer {
    id: dashDrawer
    anchorWindow: root.anchorWindow
    open: root.anchorWindow.dashboardOpen

    width: 520
    height: 320

    anchorX: root.anchorWindow.width / 2 - width / 2
    anchorY: root.anchorWindow.height + 8

    DashUI.DashboardContent { anchors.fill: parent }
  }
}