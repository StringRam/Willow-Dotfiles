import Quickshell
import QtQuick
import qs.services
import qs.modules.dropdowns

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: topEdge
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }
      implicitHeight: 4
      exclusiveZone: 0

      // Anchos estables (sin drift)
      property int third: Math.floor(width / 3)
      property int leftW: third
      property int centerW: third
      property int rightW: width - leftW - centerW

      Row {
        anchors.fill: parent

        // 1/3 izquierda: Notifs
        MouseArea {
          width: topEdge.leftW
          height: parent.height
          hoverEnabled: true

          onEntered: { Visibility.notifsHotspotHovered = true; Visibility.updateNotifsHover() }
          onExited:  { Visibility.notifsHotspotHovered = false; Visibility.updateNotifsHover() }
          onClicked: Visibility.toggleNotifsPinned()
        }

        // 1/3 centro: Dashboard
        MouseArea {
          width: topEdge.centerW
          height: parent.height
          hoverEnabled: true

          onEntered: { Visibility.dashHotspotHovered = true; Visibility.updateDashHover() }
          onExited:  { Visibility.dashHotspotHovered = false; Visibility.updateDashHover() }
          // si querés pin con click: onClicked: Visibility.toggleDashPinned()
        }

        // 1/3 derecha: vacío
        Item { width: topEdge.rightW; height: parent.height }
      }

      DropDowns { anchorWindow: topEdge }
    }
  }
}