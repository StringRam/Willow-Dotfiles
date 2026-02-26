import QtQuick
import qs.services
import qs.modules.dropdowns
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI

Item {
  id: root
  required property var anchorWindow

  Drawer {
    id: notifsDrawer
    anchorWindow: root.anchorWindow
    open: Visibility.notifsOpen
    width: 360
    height: 520
    anchorX: 12
    anchorY: root.anchorWindow.height

    onHoveredChanged: {
      Visibility.notifsPanelHovered = hovered
      Visibility.updateNotifsHover()
    }

    NotifsUI.NotifContent { anchors.fill: parent }
  }

  Drawer {
    id: dashDrawer
    anchorWindow: root.anchorWindow
    open: Visibility.dashOpen
    width: 520
    height: 320
    anchorX: root.anchorWindow.width / 2 - width / 2
    anchorY: root.anchorWindow.height

    onHoveredChanged: {
      Visibility.dashPanelHovered = hovered
      Visibility.updateDashHover()
    }

    DashUI.DashboardContent { anchors.fill: parent }
  }
}