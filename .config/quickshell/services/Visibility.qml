pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property bool launcherOpen: false
  property bool notifsOpen: false

  // Para hover-open en esquina:
  property bool notifsHotspotHovered: false
  property bool notifsPanelHovered: false

  function closeAll() {
    launcherOpen = false
    notifsOpen = false
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }

  function toggleNotifs() {
    const next = !notifsOpen
    closeAll()
    notifsOpen = next
  }

  function refreshNotifsHoverOpen() {
    // abre mientras haya hover en hotspot o panel
    notifsOpen = notifsHotspotHovered || notifsPanelHovered
  }

  Timer {
    // pequeño delay para que no “parpadee” al cruzar el borde
    id: hoverCloseTimer
    interval: 120
    repeat: false
    onTriggered: root.refreshNotifsHoverOpen()
  }

  function scheduleRefresh() { hoverCloseTimer.restart() }
}