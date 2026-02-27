pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services

Item {
  id: root
  // Le pasamos el Bar como componente (clean)
  required property Item bar

  // Insertamos el Bar “tal cual”
  Item {
    id: barHost
    anchors.fill: parent
    // reparent del item inyectado
    Component.onCompleted: root.bar.parent = barHost
  }

  // Hotspots por encima (no acoplan Bar con drawers)
  // Si no querés overlay total, reducimos height a pocos px.
  property int third: Math.floor(width / 3)
  property int leftW: third
  property int centerW: third
  property int rightW: width - leftW - centerW

  Row {
    anchors.fill: parent

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
    }

    Item { width: root.rightW; height: parent.height }
  }
}