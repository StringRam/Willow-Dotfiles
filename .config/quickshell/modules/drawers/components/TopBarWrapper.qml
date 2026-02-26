pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services

Item {
  id: root
  required property Item bar

  // fondo
  Rectangle {
    anchors.fill: parent
    color: Colours.palette.m3surfaceContainer
  }

  // inyectar contenido del bar
  Item {
    id: barHost
    anchors.fill: parent
    Component.onCompleted: root.bar.parent = barHost
  }

  // hotspots (overlay)
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