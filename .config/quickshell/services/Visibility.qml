pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property bool launcherOpen: false
  property bool notifsOpen: false

  // hover state
  property bool notifsHotspotHovered: false
  property bool notifsPanelHovered: false

  function refreshNotifsHoverOpen() {
    notifsOpen = notifsHotspotHovered || notifsPanelHovered
  }

  Timer {
    id: hoverTimer
    interval: 120
    repeat: false
    onTriggered: root.refreshNotifsHoverOpen()
  }

  function scheduleNotifsRefresh() { hoverTimer.restart() }

  function closeAll() {
    launcherOpen = false
    notifsOpen = false
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }
}