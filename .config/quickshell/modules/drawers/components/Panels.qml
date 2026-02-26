pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components
import qs.config

Item {
  id: root
  required property var anchorWindow

  // fondo visible (esto es lo que hoy no estás viendo)
  Rectangle {
    anchors.fill: parent
    color: Colours.palette.m3surfaceContainer
  }

  // contenido mínimo de barra (después lo reemplazás por Bar.qml como “contenido”)
  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: Appearance.padding.large
    anchors.rightMargin: Appearance.padding.large
    spacing: Appearance.spacing.normal

    StyledText {
      Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
      text: "Willow"
    }

    Item { Layout.fillWidth: true }

    StyledText {
      Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
      text: Qt.formatDateTime(new Date(), "HH:mm")
    }
  }

  // hotspots (para notifs/dashboard)
  // si querés que SOLO los bordes activen hover, podés reducir la altura del MouseArea.
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