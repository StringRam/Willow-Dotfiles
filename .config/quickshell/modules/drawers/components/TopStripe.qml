pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
  id: root

  // La línea visible
  property int stripeHeight: 5

  // Área clic/hover (más fácil de atinar sin cambiar apariencia)
  property int hitHeight: 14

  // 1/3 izquierda notifs, 1/3 centro dashboard
  property int third: Math.floor(width / 3)
  property int leftW: third
  property int centerW: third
  property int rightW: width - leftW - centerW

  // Línea visible (5px)
  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: root.stripeHeight

    // Elegante/subtil (podés cambiar a m3primary si querés)
    color: Colours.palette.m3outlineVariant
    opacity: 0.9
  }

  // Hitbox por encima (NO cambia apariencia)
  Row {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: root.hitHeight

    MouseArea {
      width: root.leftW
      height: parent.height
      hoverEnabled: true
      onEntered: { Visibility.notifsHotspotHovered = true; Visibility.updateNotifsHover() }
      onExited:  { Visibility.notifsHotspotHovered = false; Visibility.updateNotifsHover() }
      onClicked: Visibility.toggleNotifsPinned()
    }

    MouseArea {
      width: root.centerW
      height: parent.height
      hoverEnabled: true
      onEntered: { Visibility.dashHotspotHovered = true; Visibility.updateDashHover() }
      onExited:  { Visibility.dashHotspotHovered = false; Visibility.updateDashHover() }
      // onClicked: Visibility.toggleDashPinned()
    }

    Item { width: root.rightW; height: parent.height }
  }
}