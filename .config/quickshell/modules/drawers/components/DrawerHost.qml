import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.modules.drawers.components as DrawersUI
import qs.services

PanelWindow {
  id: host

  required property var screenModel
  required property Item dashWrapper
  required property Item notifsWrapper
  required property Item dashHitbox
  required property Item notifsHitbox

  property int stripeGap: 9

  anchors { top: true; bottom: true; left: true; right: true }
  screen: screenModel
  exclusiveZone: 0
  aboveWindows: true
  color: "transparent"

  // --- Stripe (hotspot) ---
  Item {
    id: stripeHit
    z: 30
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 14

    DrawersUI.TopStripe {
      anchors.fill: parent
      stripeHeight: 5
      hitHeight: 14
    }
  }

  readonly property int drawerTop: stripeHit.height + stripeGap

  // ✅ Fondo detrás de todo (NO debe tapar el contenido)
  DrawersUI.Backgrounds {
    id: backgrounds
    z: 0
    anchors.fill: parent
    dashWrapper: host.dashWrapper
    notifsWrapper: host.notifsWrapper
  }

  // ✅ Contenido de los paneles (encima del fondo)
  Item {
    id: contentRoot
    z: 10
    anchors.fill: parent
  }
  default property alias content: contentRoot.data

  // ✅ Mask click-through (ok)
  mask: Region {
    intersection: Intersection.Combine
    regions: [
      Region { item: stripeHit },
      Region { item: (host.dashWrapper.height > 0 ? host.dashHitbox : null) },
      Region { item: (host.notifsWrapper.height > 0 ? host.notifsHitbox : null) }
    ]
  }

  // ✅ Hover sobre hitboxes (por encima del fondo, pero no roba clicks)
  MouseArea {
    z: 20
    x: host.notifsHitbox.x
    y: host.notifsHitbox.y
    width: host.notifsHitbox.width
    height: host.notifsHitbox.height

    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    enabled: host.notifsWrapper.height > 0

    onEntered: {
      Visibility.notifsPanelHovered = true
      Visibility.updateNotifsHover()
    }
    onExited: {
      Visibility.notifsPanelHovered = false
      Visibility.updateNotifsHover()
    }
  }

  MouseArea {
    z: 20
    x: host.dashHitbox.x
    y: host.dashHitbox.y
    width: host.dashHitbox.width
    height: host.dashHitbox.height

    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    enabled: host.dashWrapper.height > 0

    onEntered: {
      Visibility.dashPanelHovered = true
      Visibility.updateDashHover()
    }
    onExited: {
      Visibility.dashPanelHovered = false
      Visibility.updateDashHover()
    }
  }

  property alias rounding: backgrounds.rounding
}