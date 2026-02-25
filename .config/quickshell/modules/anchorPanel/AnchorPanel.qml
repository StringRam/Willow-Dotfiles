import Quickshell
import QtQuick
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

      // 0 = left, 1 = center, -1 = ninguno
      property int openMenu: -1

      // hover flags (handles)
      property bool hoverLeftHandle: false
      property bool hoverCenterHandle: false

      function refreshOpen() {
        if (hoverLeftHandle || leftDrawer.hovered) { openMenu = 0; return }
        if (hoverCenterHandle || centerDrawer.hovered) { openMenu = 1; return }
        openMenu = -1
      }

      Timer {
        id: closeTimer
        interval: 120
        repeat: false
        onTriggered: topEdge.refreshOpen()
      }

      function scheduleRefresh() { closeTimer.restart() }

      Row {
        anchors.fill: parent

        MouseArea {
          width: 24
          height: parent.height
          hoverEnabled: true

          onEntered: {
            Visibility.notifsHotspotHovered = true
            Visibility.refreshNotifsHoverOpen()
          }
          onExited: {
            Visibility.notifsHotspotHovered = false
            Visibility.scheduleRefresh()
          }
        }

        MouseArea {
          width: parent.width / 3
          height: parent.height
          hoverEnabled: true

          onEntered: {
            topEdge.hoverCenterHandle = true
            topEdge.openMenu = 1
            closeTimer.stop()
          }
          onExited: {
            topEdge.hoverCenterHandle = false
            topEdge.scheduleRefresh()
          }
        }

        Item { width: parent.width / 3; height: parent.height }
      }


      // ===== Drawer centro =====
      Drawer {
        id: centerDrawer
        anchorWindow: topEdge
        open: topEdge.openMenu === 1

        width: 420
        height: 280

        anchorX: parentWindow.width/2 - width/2
        anchorY: topEdge.height

        Text { text: "CENTER"; anchors.centerIn: parent; color: "#111" }
      }
    }
  }
}