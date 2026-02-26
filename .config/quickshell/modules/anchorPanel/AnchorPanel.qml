import Quickshell
import QtQuick
import qs.services
import "."

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

      Rectangle { anchors.fill: parent; color: "#FFFFFF"; opacity: 0.9 }

      // ===== Dashboard (solo centro) =====
      property bool dashboardOpen: false
      property bool hoverDashboardHandle: false

      function refreshDashboardOpen() {
        dashboardOpen = hoverDashboardHandle || centerDrawer.hovered
      }

      Timer {
        id: closeTimer
        interval: 120
        repeat: false
        onTriggered: topEdge.refreshDashboardOpen()
      }

      function scheduleRefresh() { closeTimer.restart() }

      Row {
        anchors.fill: parent

        // Left third: Notifs
        MouseArea {
          width: parent.width / 3
          height: parent.height
          hoverEnabled: true
          onEntered: { Visibility.notifsHotspotHovered = true; Visibility.refreshNotifsHoverHold() }
          onExited:  { Visibility.notifsHotspotHovered = false; Visibility.refreshNotifsHoverHold() }
          onClicked: Visibility.toggleNotifsPinned()
        }

        // Center third: Dashboard hover
        MouseArea {
          width: parent.width / 3
          height: parent.height
          hoverEnabled: true
          onEntered: { topEdge.hoverDashboardHandle = true; closeTimer.stop(); topEdge.refreshDashboardOpen() }
          onExited:  { topEdge.hoverDashboardHandle = false; topEdge.scheduleRefresh() }
        }

        // Right third: vacío
        Item { width: parent.width / 3; height: parent.height }
      }

      // ===== Drawer centro =====
      Drawer {
        id: centerDrawer
        anchorWindow: topEdge
        open: topEdge.dashboardOpen

        width: 420
        height: 280

        anchorX: parentWindow.width/2 - width/2
        anchorY: topEdge.height

        Text { text: "CENTER"; anchors.centerIn: parent; color: "#111" }
      }

      Connections {
        target: centerDrawer
        function onHoveredChanged() { topEdge.scheduleRefresh() }
      }
    }
  }
}