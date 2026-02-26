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

      // Dashboard open state
      property bool dashboardOpen: false
      property bool hoverDashboardHandle: false

      function refreshDashboardOpen() {
        // el drawer lo maneja DropDowns; acá solo decidís si debería abrir
        dashboardOpen = hoverDashboardHandle || dropdownsDashHovered
      }

      // DropDowns necesita saber si el drawer está hovered.
      // Si tu Drawer.qml expone hovered, lo podés bridgear.
      property bool dropdownsDashHovered: false

      Timer {
        id: closeTimer
        interval: 120
        repeat: false
        onTriggered: topEdge.refreshDashboardOpen()
      }
      function scheduleRefresh() { closeTimer.restart() }

      Row {
        anchors.fill: parent

        // 1/3 izquierda: NotifCenter
        MouseArea {
          width: parent.width / 3
          height: parent.height
          hoverEnabled: true

          onEntered: {
            Visibility.notifsHotspotHovered = true
            Visibility.onNotifsHoverChanged()
          }
          onExited: {
            Visibility.notifsHotspotHovered = false
            Visibility.onNotifsHoverChanged()
          }
          onClicked: Visibility.toggleNotifsPinned()
        }

        // 1/3 centro: Dashboard
        MouseArea {
          width: parent.width / 3
          height: parent.height
          hoverEnabled: true

          onEntered: {
            topEdge.hoverDashboardHandle = true
            closeTimer.stop()
            topEdge.refreshDashboardOpen()
          }
          onExited: {
            topEdge.hoverDashboardHandle = false
            topEdge.scheduleRefresh()
          }
        }

        // 1/3 derecha: vacío (no abre nada)
        Item {
          width: parent.width / 3
          height: parent.height
        }
      }

      // Aquí se instancian ambos drawers
      DropDowns {
        id: dropdowns
        anchorWindow: topEdge
      }
    }
  }
}