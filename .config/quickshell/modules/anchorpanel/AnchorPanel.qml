import Quickshell
import QtQuick
import qs.services
import "./DropDowns.qml"

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

        // Hotspot Notifs
        MouseArea {
          width: 24
          height: parent.height
          hoverEnabled: true

          onEntered: {
            Visibility.notifsHotspotHovered = true
            Visibility.refreshNotifsHoverHold()
          }
          onExited: {
            Visibility.notifsHotspotHovered = false
            Visibility.refreshNotifsHoverHold()
          }
          onClicked: Visibility.toggleNotifsPinned()
        }

        // Handle Dashboard (resto)
        MouseArea {
          width: parent.width - 24
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
      }

      // Aquí se instancian ambos drawers
      DropDowns {
        id: dropdowns
        anchorWindow: topEdge
      }
    }
  }
}