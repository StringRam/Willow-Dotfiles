pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property bool launcherOpen: false

  // --- Notifs: hover + pin (click) ---
  property bool notifsPinned: false          // abre/cierra por click
  property bool notifsHotspotHovered: false  // hover esquina
  property bool notifsPanelHovered: false    // hover panel
  property bool notifsHoverHold: false       // estado “hold” por hover con delay

  // Visible final (lo usa NotifCenter)
  readonly property bool notifsOpen: notifsPinned || notifsHoverHold

  function toggleNotifsPinned() {
    notifsPinned = !notifsPinned
    if (!notifsPinned) refreshNotifsHoverHold()
  }

  // Compat: tu Bar llama toggleNotifs()
  function toggleNotifs() {
    toggleNotifsPinned()
  }

  function closeNotifs() {
    notifsPinned = false
    notifsHotspotHovered = false
    notifsPanelHovered = false
    notifsHoverHold = false
  }

  function refreshNotifsHoverHold() {
    if (notifsHotspotHovered || notifsPanelHovered) {
      notifsHoverHold = true
      hoverCloseTimer.stop()
    } else {
      scheduleNotifsHoverClose()
    }
  }

  Timer {
    id: hoverCloseTimer
    interval: 120
    repeat: false
    onTriggered: {
      if (!root.notifsPinned && !(root.notifsHotspotHovered || root.notifsPanelHovered))
        root.notifsHoverHold = false
    }
  }

  function scheduleNotifsHoverClose() {
    hoverCloseTimer.restart()
  }

  function closeAll() {
    launcherOpen = false
    closeNotifs()
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }
}