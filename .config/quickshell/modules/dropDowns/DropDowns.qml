import QtQuick
import qs.services
import "./Drawer.qml"
import "../notifs/NotifContent.qml" as NotifsUI
import "../dashboard/DashboardContent.qml" as DashUI

Item {
  id: root
  required property PanelWindow anchorWindow

  // ===== NOTIFS drawer (esquina izquierda) =====
  Drawer {
    id: notifsDrawer
    anchorWindow: root.anchorWindow
    open: Visibility.notifsOpen

    width: 360
    height: 520

    anchorX: 12
    anchorY: root.anchorWindow.height + 8

    onHoveredChanged: {
      Visibility.notifsPanelHovered = hovered
      Visibility.refreshNotifsHoverHold()
    }

    NotifsUI.NotifContent { anchors.fill: parent }
  }

  // ===== DASH drawer (centro) =====
  Drawer {
    id: dashDrawer
    anchorWindow: root.anchorWindow
    open: root.anchorWindow.dashboardOpen   // lo manejás en AnchorPanel

    width: 520
    height: 320

    anchorX: root.anchorWindow.width/2 - width/2
    anchorY: root.anchorWindow.height + 8

    DashUI.DashboardContent { anchors.fill: parent }
  }
}